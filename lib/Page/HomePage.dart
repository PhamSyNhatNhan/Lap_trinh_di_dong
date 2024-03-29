import 'package:flutter/material.dart';
import 'package:nhonn/MaterialPage/CommunityMat.dart';
import 'package:nhonn/MaterialPage/ExploreMat.dart';
import 'package:nhonn/MaterialPage/ProfileMat.dart';
import 'package:nhonn/Page/Upload.dart';
import 'package:nhonn/Value/color.dart';
import 'package:nhonn/Value/image.dart';
import 'package:nhonn/main.dart';

import 'ComunityPage.dart';
import 'DiscoverPage.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSignOut;
  const HomePage({Key? key, required this.onSignOut}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int index = 0;

  void select(int page) {
    setState(() {
      index = page;
    });
  }

  List<Widget> pages = [
    DiscoverPage(),
    ComunityPage(),
    ProfileMat()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: select,
        unselectedFontSize: 14,
        selectedFontSize: 14,
        selectedItemColor: inActiveColor,
        unselectedItemColor: unActiveColor,
        selectedIconTheme: const IconThemeData(color: inActiveColor),
        backgroundColor: bottomBarColor,
        items: [
          BottomNavigationBarItem(
            label: "Khám phá",
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: "Cộng đồng",
            icon: Icon(Icons.soup_kitchen_outlined),
          ),
          BottomNavigationBarItem(
            label: "Hồ sơ",
            icon: Container(
              width: 25,
              height: 25,
              decoration: index == 2
                  ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: inActiveColor,
                  width: 2,
                ),
              )
                  : null,
              child: CircleAvatar(
                radius: 10.5,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.network(
                    user.userImage == '' ? defaultImage : user.userImage,
                    height: 21,
                    width: 21,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadPage(
              ),
            ),
          );
        },
        backgroundColor: backgroundColor,
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          color: inActiveColor,
          size: 30,
        ),
      ),

    );
  }
}
































