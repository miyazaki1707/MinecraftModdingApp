import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minecraft_app/models/block_model.dart';
import 'package:minecraft_app/services/block_manager.dart';

class BlockCreation extends StatefulWidget {
  const BlockCreation({super.key});

  @override
  State<StatefulWidget> createState() => _BlockCreationState();
}

class _BlockCreationState extends State<BlockCreation> {
  final blockTitleController = TextEditingController();
  final secondsToDestroyController = TextEditingController();
  File? _selectedImage;
  bool isDestructibleByExplosion = true;
  double secondsToDestroy = 0;

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return null;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(30, 168, 102, 1),
          title: const Text('Block creation'),
        ),
        backgroundColor: const Color.fromRGBO(52, 52, 52, 1),
        body: Container(
          margin: const EdgeInsets.only(left: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 28),
                child: const Text(
                  "Name",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 21),
                width: 222,
                child: TextField(
                  controller: blockTitleController,
                  autofocus: false,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(38, 38, 38, 1),
                    hintText: 'Block’s title',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  "Texture",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400),
                ),
              ),
              TextButton(
                onPressed: () {
                  _pickImageFromGallery();
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, right: 40, left: 40),
                    backgroundColor: const Color.fromRGBO(30, 168, 102, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text(
                  "Select",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 18),
                child: const Text(
                  "Destructible by Explosion",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Transform.scale(
                    scale: 1.5,
                    child: Switch(
                        value: isDestructibleByExplosion,
                        activeColor: const Color.fromRGBO(0, 168, 102, 1),
                        onChanged: (bool value) {
                          setState(() {
                            isDestructibleByExplosion = value;
                          });
                        }),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 18),
                child: const Text(
                  "Seconds to destroy",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 21),
                width: 80,
                child: TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                  ],
                  controller: secondsToDestroyController,
                  autofocus: false,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300),
                  onChanged: (value) {
                    if (double.tryParse(value) != null) {
                      double doubleValue = double.parse(value);
                      if (doubleValue < 0 || doubleValue > 1) {
                        secondsToDestroyController.text = '0';
                      }
                    }
                    secondsToDestroy =
                        double.parse(secondsToDestroyController.text);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(38, 38, 38, 1),
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: TextButton(
                  onPressed: () async {
                    final bm = BlockManager();
                    BlockModel block = BlockModel(
                        blockTitleController.text,
                        _selectedImage!.path,
                        isDestructibleByExplosion,
                        secondsToDestroy);
                    await bm.blockInit(block);
                    if (!context.mounted) return;
                    Navigator.pop(context, block);
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, right: 40, left: 40),
                      backgroundColor: const Color.fromRGBO(30, 168, 102, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    "Create",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
