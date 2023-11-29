import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:minecraft_app/models/block_model.dart';
import 'package:minecraft_app/screens/block_creation.dart';

class ItemCard extends StatelessWidget {
  final String itemTitle;
  final File imageFile;
  const ItemCard(this.itemTitle, this.imageFile, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      body: GestureDetector(
        onTap: () {
          log("adsda");
        },
        child: SizedBox(
          width: 103,
          height: 149,
          child: Stack(
            children: [
              Positioned(
                left: 7,
                top: 19,
                child: Container(
                  width: 96,
                  height: 109,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF4C4C4C),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 79,
                  height: 79,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 91,
                child: Text(
                  itemTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
