import 'package:flutter/material.dart';
import 'package:minecraft_application_1/models/block_model.dart';
//import 'package:minecraft_app/models/block_model.dart';
//import 'package:minecraft_app/screens/block_creation.dart';
//import 'package:minecraft_app/widgets/item_widget.dart';

void main() {
  runApp(const HomeApp());
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<StatefulWidget> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  List<BlockModel> blocks = [];

  /*Future<void> _navigateToBlockCreation(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SecondRoute()),
      );
      setState(() {
        blocks.add(result as BlockModel);
      });
      return;
    } catch (e) {}
  } */

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
                Image.asset('images/block_icon.png'),
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
              // _navigateToBlockCreation(context);
            },
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Image.asset('images/item_icon.png'),
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
            Column(
              children: [
                if (blocks.isNotEmpty)
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
                if (blocks.isNotEmpty)
                  const Divider(
                    color: Color.fromRGBO(96, 94, 94, 1),
                    indent: 20,
                    endIndent: 20,
                  ),
                /*Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0, top: 16),
                    height: MediaQuery.of(context).size.height - 50,
                    child: GridView.builder(
                      itemCount: blocks.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 130,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return ItemCard(blocks[index]);
                      },
                    ),
                  ),
                ), */
              ],
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
        ),
      ),
    );
  }
}
