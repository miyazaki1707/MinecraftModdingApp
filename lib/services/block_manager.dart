import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:minecraft_app/models/block_model.dart';
import 'package:path_provider/path_provider.dart';

class BlockManager {
  Future blockInit(BlockModel block) async {
    final directory = await getExternalStorageDirectory();
    File file = File('${directory!.path}/Mod/MyPackR/blocks.json');
    if (!file.existsSync()) {
      await Directory('${directory.path}/Mod/MyPackR').create(recursive: true);
      File file = File('${directory.path}/Mod/MyPackR/blocks.json');
      Map<String, dynamic> jsonData = {
        "format_version": "1.20",
        "demo:${block.title.toLowerCase()}": {
          "textures": block.title.toLowerCase(),
          "carried_textures": block.title.toLowerCase(),
          "brightness_gamma": 1,
          "sound": "stone"
        }
      };
      String jsonString = jsonEncode(jsonData);
      file.writeAsStringSync(jsonString);
    } else {
      File file = File('${directory.path}/Mod/MyPackR/blocks.json');
      final data = await file.readAsString();
      Map<String, dynamic> jsonData = await jsonDecode(data);
      jsonData['demo:${block.title.toLowerCase()}'] = {
        "textures": block.title.toLowerCase(),
        "carried_textures": block.title.toLowerCase(),
        "brightness_gamma": 1,
        "sound": "stone"
      };
      String jsonString = jsonEncode(jsonData);
      File jsonFile = File('${directory.path}/Mod/MyPackR/blocks.json');
      jsonFile.writeAsStringSync(jsonString);
    }

    await _addDataToTerrainTexture(block.title);
    await _addTextureFile(block);
    await _addLangData(block.title);

    if (Directory("${directory.path}/Mod/MyPackB/blocks").existsSync()) {
      _addBlockBehavior(block);
    } else {
      Directory("${directory.path}/Mod/MyPackB/blocks")
          .createSync(recursive: true);
      _addBlockBehavior(block);
    }
  }

  Future _addTextureFile(BlockModel block) async {
    final directory = await getExternalStorageDirectory();
    final fullPath = '${directory!.path}/Mod/MyPackR/textures/blocks';
    if (!(await Directory(fullPath).exists())) {
      await Directory(fullPath).create(recursive: true);
    }
    final file = File('$fullPath/${block.title.toLowerCase()}.png');
    await file.writeAsBytes(await File(block.imageUrl).readAsBytes());

    block.imageUrl = file.path;
  }

  Future _addLangData(String blockName) async {
    final directory = await getExternalStorageDirectory();
    if (Directory('${directory!.path}/Mod/MyPackR/texts').existsSync()) {
      File file = File('${directory.path}/Mod/MyPackR/texts/en_US.lang');
      String data = file.readAsStringSync();
      data += "\n" + "tile.demo:${blockName.toLowerCase()}.name=$blockName";
      file.writeAsStringSync(data);
    } else {
      await Directory('${directory.path}/Mod/MyPackR/texts')
          .create(recursive: true);
      File file = File('${directory.path}/Mod/MyPackR/texts/en_US.lang');
      file.writeAsStringSync(
          "tile.demo:${blockName.toLowerCase()}.name=$blockName");
    }
  }

  Future _addDataToTerrainTexture(String blockName) async {
    String jsonString = "";
    final directory = await getExternalStorageDirectory();
    if (await Directory('${directory!.path}/Mod/MyPackR/textures').exists()) {
      if (File('${directory.path}/Mod/MyPackR/textures/terrain_texture.json')
          .existsSync()) {
        File file =
            File('${directory.path}/Mod/MyPackR/textures/terrain_texture.json');
        final data = await file.readAsString();
        Map<String, dynamic> jsonData = await jsonDecode(data);
        jsonData["texture_data"][blockName.toLowerCase()] = {
          "textures": "textures/blocks/${blockName.toLowerCase()}"
        };
        jsonString = jsonEncode(jsonData);
      } else {
        File file =
            File('${directory.path}/Mod/MyPackR/textures/terrain_texture.json');
        Map<String, dynamic> jsonData = {
          "resource_pack_name": "resource_pack",
          "texture_name": "atlas.terrain",
          "padding": 8,
          "num_mip_levels": 4,
          "texture_data": {
            blockName.toLowerCase(): {
              "textures": "textures/blocks/${blockName.toLowerCase()}"
            },
          }
        };
        jsonString = jsonEncode(jsonData);
      }

      File jsonFile =
          File('${directory.path}/Mod/MyPackR/textures/terrain_texture.json');
      jsonFile.writeAsStringSync(jsonString);
    } else {
      await Directory('${directory.path}/Mod/MyPackR/textures')
          .create(recursive: true);
      File file =
          File('${directory.path}/Mod/MyPackR/textures/terrain_texture.json');
      Map<String, dynamic> jsonData = {
        "resource_pack_name": "resource_pack",
        "texture_name": "atlas.terrain",
        "padding": 8,
        "num_mip_levels": 4,
        "texture_data": {
          blockName.toLowerCase(): {
            "textures": "textures/blocks/${blockName.toLowerCase()}"
          },
        }
      };
      String jsonString = jsonEncode(jsonData);
      file.writeAsStringSync(jsonString);
    }
  }

  Future _addBlockBehavior(BlockModel block) async {
    log(block.secondsToDestroy.toString());
    final directory = await getExternalStorageDirectory();
    var file = File(
        "${directory!.path}/Mod/MyPackB/blocks/${block.title.toLowerCase()}.json");
    Map<String, dynamic> jsonData = {
      "format_version": "1.20",
      "minecraft:block": {
        "description": {"identifier": "demo:${block.title.toLowerCase()}"},
        "components": {
          "minecraft:destructible_by_explosion":
              block.isDestructibleByExplosion,
          "minecraft:destructible_by_mining": {
            "seconds_to_destroy": block.secondsToDestroy
          }
        }
      }
    };

    String jsonString = jsonEncode(jsonData);
    file.writeAsStringSync(jsonString);
  }
}
