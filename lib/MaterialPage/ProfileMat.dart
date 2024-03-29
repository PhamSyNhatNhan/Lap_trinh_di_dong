import 'package:flutter/material.dart';
import 'package:intrinsic_dimension/intrinsic_dimension.dart';
import 'package:nhonn/MaterialPage/ActivityMat.dart';
import 'package:nhonn/MaterialPage/CookbookMat.dart';
import 'package:nhonn/MaterialPage/SavedRecipesMat.dart';
import 'package:nhonn/Value/color.dart';
import 'package:nhonn/Value/font.dart';
import 'package:nhonn/main.dart';

class ProfileMat extends StatefulWidget {

  @override
  State<ProfileMat> createState() => _ProfileMat();
}

class _ProfileMat extends State<ProfileMat> {
  int _currentPage = 0;

  double _sliverToBoxAdapterHeight = 0.0;

  void selectTab(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  List<Widget> pages = [
    SavedRecipesMat(),
    CookbookMat(),
    ActivityMat()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Positioned(
                      top: -25,
                      left: 0,
                      right: 0,
                      child: Image.network(
                        'https://i.imgur.com/nqOFubw.png',
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(.3),
                      ),
                    ),

                    Positioned(
                      top: 50,
                      right: 20,
                      child: IconButton(
                        icon: Icon(
                          Icons.settings_outlined,
                          color: inActiveColor,
                          size: 30,
                        ),
                        onPressed: () {

                        },
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: Image.network(
                                  user.userImage,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            user.userName,
                            style: TextStyle(
                              color: defaultColor,
                              fontSize: 25,
                              fontFamily: loginTextFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 15,
                                      fontFamily: loginTextFont,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Text(
                                    "đánh giá",
                                    style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 12,
                                      fontFamily: loginTextFont,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 15,
                                      fontFamily: loginTextFont,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Text(
                                    "tips",
                                    style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 12,
                                      fontFamily: loginTextFont,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 15,
                                      fontFamily: loginTextFont,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Text(
                                    "ảnh",
                                    style: TextStyle(
                                      color: defaultColor,
                                      fontSize: 12,
                                      fontFamily: loginTextFont,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              SliverAppBar(
                pinned: true,
                floating: true,
                shadowColor: profileShadowColor,
                surfaceTintColor: Colors.white,

                flexibleSpace: Center(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        selectTab(0);
                      },

                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Center(
                            child: Text(
                              'Công thức',
                              style: TextStyle(
                                color: _currentPage == 0 ? inActiveColor : defaultColor,
                                fontSize: 14,
                                fontFamily: loginTextFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        selectTab(1);
                      },

                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Center(
                            child: Text(
                              'Sách nấu ăn',
                              style: TextStyle(
                                color: _currentPage == 1 ? inActiveColor : defaultColor,
                                fontSize: 14,
                                fontFamily: loginTextFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        selectTab(2);
                      },

                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Center(
                            child:  Text(
                              'Hoạt động',
                              style: TextStyle(
                                color: _currentPage == 2 ? inActiveColor : defaultColor,
                                fontSize: 14,
                                fontFamily: loginTextFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: IntrinsicDimension(
                listener: (_, __, height, ____) {
                  setState(() {
                    _sliverToBoxAdapterHeight = height;
                  });
                },
                builder: (_, __, ___, ____) => pages[_currentPage],
              ),
            ),
          ],
        )
      ),
    );
  }

}