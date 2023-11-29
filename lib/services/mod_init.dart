import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:minecraft_app/models/block_model.dart';
import 'package:minecraft_app/models/item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ModInitializer {
  String? _resourceUUID;

  Future<void> initializeModStruct() async {
    Map<String, dynamic> map = {};
    final directory = await getExternalStorageDirectory();
    if (await Directory('${directory!.path}/Mod').exists()) {
      return;
    } else {
      await Directory('${directory.path}/Mod').create(recursive: true);
      _resourceUUID = await _generateManifest(false);
      _generateManifest(true);
    }
  }

  Future<String> _generateManifest(bool isBehavior) async {
    final directory = await getExternalStorageDirectory();
    Map<String, dynamic> manifestMap = {
      "format_version": 2,
      "header": {
        "description": "",
        "name": "",
        "uuid": "",
        "version": [1, 0, 0],
        "min_engine_version": [1, 20, 6]
      },
      "modules": [
        {
          "description": "",
          "type": "",
          "uuid": "",
          "version": [1, 0, 0]
        }
      ]
    };

    var uuid = const Uuid();
    var generatedUuid = uuid.v4();
    var generatedUuidForModule = uuid.v4();

    if (!isBehavior) {
      manifestMap["header"]["description"] = "This is a Resource pack";
      manifestMap["header"]["name"] = "Resource pack";
      manifestMap["header"]["uuid"] = generatedUuid;
      manifestMap["modules"][0]["description"] = "Resource pack";
      manifestMap["modules"][0]["type"] = "resources";
      manifestMap["modules"][0]["uuid"] = generatedUuidForModule;
      String jsonString = jsonEncode(manifestMap);
      String filePath = '${directory!.path}/Mod/MyPackR';
      Directory(filePath).createSync();
      File file = File('$filePath/manifest.json');
      file.writeAsStringSync(jsonString);
      return manifestMap["header"]["uuid"];
    } else {
      manifestMap["header"]["description"] = "This is a Behavior pack";
      manifestMap["header"]["name"] = "Behavior pack";
      manifestMap["header"]["uuid"] = generatedUuid;
      manifestMap["modules"][0]["description"] = "Behavior pack";
      manifestMap["modules"][0]["type"] = "data";
      manifestMap["modules"][0]["uuid"] = generatedUuidForModule;
      manifestMap["dependencies"] = [
        {
          "uuid": _resourceUUID,
          "version": [1, 0, 0]
        }
      ];
      String jsonString = jsonEncode(manifestMap);
      String filePath = '${directory!.path}/Mod/MyPackB';
      Directory(filePath).createSync();
      File file = File('$filePath/manifest.json');
      file.writeAsStringSync(jsonString);
      return manifestMap["header"]["uuid"];
    }
  }

  Future<List<BlockModel>> loadBlocks() async {
    final directory = await getExternalStorageDirectory();
    List<BlockModel> blocks = [];
    final blocksPath = "${directory!.path}/Mod/MyPackB/blocks";
    if (await Directory(blocksPath).exists()) {
      List<FileSystemEntity> files = Directory(blocksPath).listSync();
      for (var file in files) {
        if (file is File) {
          try {
            String contents = file.readAsStringSync();
            Map<String, dynamic> jsonContent = json.decode(contents);
            String blockTitle =
                jsonContent["minecraft:block"]["description"]["identifier"];
            Map<String, dynamic> components =
                jsonContent["minecraft:block"]["components"];
            blockTitle = blockTitle.split(':')[1];
            BlockModel block = BlockModel(
                blockTitle,
                '${directory.path}/Mod/MyPackR/textures/blocks/$blockTitle.png',
                components["minecraft:destructible_by_explosion"],
                components["minecraft:destructible_by_mining"]
                    ["seconds_to_destroy"]);
            blocks.add(block);
          } catch (e) {
            log('Exception while reading a file - ${file.path}: $e');
          }
        }
      }
    }
    return blocks;
  }

  Future<List<ItemModel>> loadItems() async {
    List<ItemModel> items = [];
    final directory = await getExternalStorageDirectory();
    final itemsPath = "${directory!.path}/Mod/MyPackB/items";
    if (await Directory(itemsPath).exists()) {
      List<FileSystemEntity> files = Directory(itemsPath).listSync();
      for (var file in files) {
        if (file is File) {
          try {
            String contents = file.readAsStringSync();
            Map<String, dynamic> jsonContent = json.decode(contents);
            String itemTitle =
                jsonContent["minecraft:item"]["description"]["identifier"];
            Map<String, dynamic> components =
                jsonContent["minecraft:item"]["components"];
            itemTitle = itemTitle.split(':')[1];
            ItemModel item = ItemModel(itemTitle,
                '${directory.path}/Mod/MyPackR/textures/items/$itemTitle.png',
                stackSize: components["minecraft:max_stack_size"]);
            items.add(item);
          } catch (e) {
            log('Exception while reading a file - ${file.path}: $e');
          }
        }
      }
    }
    return items;
  }
}
