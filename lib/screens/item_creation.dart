import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minecraft_app/models/item_model.dart';
import 'package:minecraft_app/services/item_manager.dart';
import 'package:path_provider/path_provider.dart';

class ItemCreation extends StatefulWidget {
  const ItemCreation({super.key});
  @override
  State<StatefulWidget> createState() => _ItemCreationState();
}

class _ItemCreationState extends State<ItemCreation> {
  final itemTitleController = TextEditingController();
  final itemStackSizeController = TextEditingController();
  File? _selectedImage;

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
          title: const Text('Item creation'),
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
                  controller: itemTitleController,
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
                    hintText: 'Item’s title',
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
                margin: const EdgeInsets.only(bottom: 8, top: 21),
                child: const Text(
                  "Stack size",
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: itemStackSizeController,
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
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final im = ItemManager();
                  final stackSize =
                      int.tryParse(itemStackSizeController.text) ?? 64;
                  ItemModel item = ItemModel(
                      itemTitleController.text, _selectedImage!.path,
                      stackSize: stackSize);
                  await im.itemInit(item);
                  if (!context.mounted) return;
                  Navigator.pop(context, item);
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
            ],
          ),
        ));
  }
}
