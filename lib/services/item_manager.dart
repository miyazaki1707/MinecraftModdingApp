import 'dart:convert';
import 'dart:io';

import 'package:minecraft_app/models/item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

class ItemManager {
  Future itemInit(ItemModel item) async {
    final directory = await getExternalStorageDirectory();
    await _addDataToItemTexture(item.title);
    await _addLangData(item.title);
    await _addTextureFile(item);

    if (Directory("${directory!.path}/Mod/MyPackB/items").existsSync()) {
      await _addBehavior(item);
    } else {
      Directory("${directory.path}/Mod/MyPackB/items")
          .createSync(recursive: true);
      await _addBehavior(item);
    }
  }

  Future _addLangData(String itemName) async {
    final directory = await getExternalStorageDirectory();
    if (Directory('${directory!.path}/Mod/MyPackR/texts').existsSync()) {
      File file = File('${directory.path}/Mod/MyPackR/texts/en_US.lang');
      String data = file.readAsStringSync();
      data += "\n" + "item.demo:${itemName.toLowerCase()}.name=$itemName";
      file.writeAsStringSync(data);
    } else {
      await Directory('${directory.path}/Mod/MyPackR/texts')
          .create(recursive: true);
      File file = File('${directory.path}/Mod/MyPackR/texts/en_US.lang');
      file.writeAsStringSync(
          "item.demo:${itemName.toLowerCase()}.name=$itemName");
    }
  }

  Future _addTextureFile(ItemModel block) async {
    final directory = await getExternalStorageDirectory();
    final fullPath = '${directory!.path}/Mod/MyPackR/textures/items';
    if (!(await Directory(fullPath).exists())) {
      await Directory(fullPath).create(recursive: true);
    }
    final file = File('$fullPath/${block.title.toLowerCase()}.png');
    await file.writeAsBytes(await File(block.imageUrl).readAsBytes());

    block.imageUrl = file.path;
  }

  Future _addDataToItemTexture(String itemName) async {
    String jsonString = "";
    final directory = await getExternalStorageDirectory();
    if (await Directory('${directory!.path}/Mod/MyPackR/textures').exists()) {
      if (File('${directory.path}/Mod/MyPackR/textures/item_texture.json')
          .existsSync()) {
        File file =
            File('${directory.path}/Mod/MyPackR/textures/item_texture.json');
        final data = await file.readAsString();
        Map<String, dynamic> jsonData = await jsonDecode(data);
        jsonData["texture_data"][itemName.toLowerCase()] = {
          "textures": "textures/items/${itemName.toLowerCase()}"
        };
        jsonString = jsonEncode(jsonData);
      } else {
        File file =
            File('${directory.path}/Mod/MyPackR/textures/item_texture.json');
        Map<String, dynamic> jsonData = {
          "resource_pack_name": "resource_pack",
          "texture_name": "atlas.items",
          "texture_data": {
            itemName.toLowerCase(): {
              "textures": "textures/items/${itemName.toLowerCase()}"
            },
          }
        };
        jsonString = jsonEncode(jsonData);
      }
      File jsonFile =
          File('${directory.path}/Mod/MyPackR/textures/item_texture.json');
      jsonFile.writeAsStringSync(jsonString);
    } else {
      await Directory('${directory.path}/Mod/MyPackR/textures')
          .create(recursive: true);
      File file =
          File('${directory.path}/Mod/MyPackR/textures/item_texture.json');
      Map<String, dynamic> jsonData = {
        "resource_pack_name": "resource_pack",
        "texture_name": "atlas.items",
        "texture_data": {
          itemName.toLowerCase(): {
            "textures": "textures/items/${itemName.toLowerCase()}"
          },
        }
      };
      String jsonString = jsonEncode(jsonData);
      file.writeAsStringSync(jsonString);
    }
  }

  Future _addBehavior(ItemModel item) async {
    final directory = await getExternalStorageDirectory();
    var file = File(
        "${directory!.path}/Mod/MyPackB/items/${item.title.toLowerCase()}.json");
    Map<String, dynamic> jsonData = {
      "format_version": "1.20",
      "minecraft:item": {
        "description": {
          "identifier": "demo:${item.title.toLowerCase()}",
          "category": "Items"
        },
        "components": {
          "minecraft:render_offsets": "apple",
          "minecraft:hand_equipped": false,
          "minecraft:stacked_by_data": true,
          "minecraft:max_stack_size": item.stackSize,
          "minecraft:display_name": {"value": item.title},
          "minecraft:icon": item.title.toLowerCase()
        }
      }
    };

    String jsonString = jsonEncode(jsonData);
    file.writeAsStringSync(jsonString);
  }
}
