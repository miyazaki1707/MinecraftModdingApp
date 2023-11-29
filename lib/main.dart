import 'dart:io';
import 'package:flutter/material.dart';
import 'package:minecraft_app/models/block_model.dart';
import 'package:minecraft_app/models/item_model.dart';
import 'package:minecraft_app/screens/block_creation.dart';
import 'package:minecraft_app/screens/item_creation.dart';
import 'package:minecraft_app/services/mod_init.dart';
import 'package:minecraft_app/widgets/item_widget.dart';

void main() {
  runApp(const HomeApp());
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});
  @override
  State<StatefulWidget> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  late Future<List<BlockModel>> blocksFuture;
  late Future<List<ItemModel>> itemsFuture;
  final mod = ModInitializer();

  @override
  void initState() {
    super.initState();
    blocksFuture = mod.loadBlocks();
    itemsFuture = mod.loadItems();
  }

  Future<void> _navigateToBlockCreation(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BlockCreation()),
      );
      List<BlockModel> blocks = await blocksFuture;
      setState(() {
        blocks.add(result as BlockModel);
      });
      return;
    } catch (e) {}
  }

  Future<void> _navigateToItemCreation(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ItemCreation()),
      );
      List<ItemModel> items = await itemsFuture;
      setState(() {
        items.add(result as ItemModel);
      });
      return;
    } catch (e) {}
  }

  Widget offsetPopup() => PopupMenuButton<int>(
        color: const Color.fromRGBO(76, 76, 76, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Image.asset('assets/images/block_icon.png'),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Blocks",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            onTap: () {
              _navigateToBlockCreation(context);
            },
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Image.asset('assets/images/item_icon.png'),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Items",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            onTap: () => _navigateToItemCreation(context),
          ),
        ],
        icon: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: ShapeDecoration(
            color: const Color.fromRGBO(30, 168, 102, 100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(4, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white70),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(30, 168, 102, 1),
            ),
            backgroundColor: const Color.fromRGBO(52, 52, 52, 1),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Blocks",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color.fromRGBO(96, 94, 94, 1),
                        indent: 20,
                        endIndent: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: 300,
                        child: FutureBuilder(
                            future: blocksFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<BlockModel> blocks = snapshot.data!;
                                return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: blocks.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 145,
                                    mainAxisExtent: 160,
                                  ),
                                  itemBuilder: (context, index) {
                                    return ItemCard(blocks[index].title,
                                        File(blocks[index].imageUrl));
                                  },
                                );
                              }
                            }),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 20, left: 10, bottom: 10),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Items",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color.fromRGBO(96, 94, 94, 1),
                        indent: 20,
                        endIndent: 20,
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: 300,
                          child: FutureBuilder(
                              future: itemsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  List<ItemModel> items = snapshot.data!;
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: items.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 145,
                                      mainAxisExtent: 160,
                                    ),
                                    itemBuilder: (context, index) {
                                      return ItemCard(items[index].title,
                                          File(items[index].imageUrl));
                                    },
                                  );
                                }
                              }))
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: offsetPopup(),
                  ),
                ),
              ],
            )));
  }
}
