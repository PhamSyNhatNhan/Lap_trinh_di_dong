  import 'dart:ffi';

import 'package:flutter/material.dart';
  import 'package:mysql_client/mysql_client.dart';

  import 'package:nhonn/Page/SearchPage.dart';
  import 'package:nhonn/Page/DiscoverPage.dart';
  import '../Value/color.dart';
import '../Value/image.dart';
import '../class/Dish.dart';
  import '../class/DishImage.dart';
  import '../main.dart';
import 'DetailDish.dart';

class ComunityPage extends StatefulWidget {
  const ComunityPage({Key? key}) : super(key: key);

  @override
  State<ComunityPage> createState() => _ComunityPage();
}

class _ComunityPage extends State<ComunityPage> {
  final List<PostCard_> _postList = [];
  bool _isLoaded = false;


  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData()  async {
    try{
      String query = "select dishId from DishCollection where userId = '" + user.userId + "'";
      var result = await conn.execute(query);

      for (final row in result.rows){
        List<DishImage> _listDishImages = [];
        query = "select dishImage, dishImageStatus from DishImage where dishId = '" + row.colByName("dishId") + "' order by dishImageStatus desc";
        result = await conn.execute(query);

        for(final rowj in result.rows) {
          DishImage di = new DishImage(rowj.colByName("dishImage"), rowj.colByName("dishImageStatus"));
          _listDishImages.add(di);
        }

        query = "select * from Dish where dishId = '" + row.colByName("dishId") + "'";
        result = await conn.execute(query);

        for(final rowj in result.rows) {
          Dish dish_ = new Dish(rowj.colByName("dishId"),
              rowj.colByName("dishName"),
              rowj.colByName("dishDecription"),
              rowj.colByName("dishDay"),
              rowj.colByName("dishTimeCook"),
              rowj.colByName("dishTimePrepare"),
              rowj.colByName("dishUp"),
              rowj.colByName("dishDown"),
              _listDishImages);

          UserLite userLiteTmp = await _getUserLite(dish_.dishId);
          String colletTmp = await _getColection(dish_.dishId);
          String comTmp = await _getComment(dish_.dishId);
          
          PostCard_ tmp = new PostCard_(dish_, userLiteTmp, colletTmp, comTmp);
          _postList.add(tmp);
          break;
        }
      }

      setState(() {
        _isLoaded = true;
      });
    }
    catch(e){
      print('Có lỗi' + e.toString());
    }
  }

  Future<UserLite> _getUserLite(String dish_)  async {
    try{
      var result = await conn.execute(
        "select userAccount.userId, userAccount.userName, userAccount.userImage from userAccount inner join DishCollection where userAccount.userId = DishCollection.userId and DishCollection.dishCollectionStatus = '1' and DishCollection.dishId = :_dishId",
        {
          "_dishId": dish_,
        },
      );

      for(final row in result.rows) {
        UserLite _userTmp = new UserLite(
            row.colByName("userId") == null ? '' : row.colByName("userId"),
            row.colByName("userName") == null ? '' : row.colByName("userName"),
            row.colByName("userImage") == null ? '' : row.colByName("userImage"));
        return _userTmp;
      }
      return UserLite('', '', '');
    }
    catch(e){
      return UserLite('', '', '');
    }
  }

  Future<String> _getColection(String dish_)  async {
    try{
      var result = await conn.execute(
        "select count(*) from DishCollection where dishId = :_dishId and dishCollectionStatus = 0",
        {
          "_dishId": dish_,
        },
      );

      for(final row in result.rows) {
        return row.colByName("count(*)");
      }
      return '0';
    }
    catch(e){
      return '0';
    }
  }

  Future<String> _getComment(String dish_)  async {
    try{
      var result = await conn.execute(
        "select count(*) from DishComment where dishId = :_dishId",
        {
          "_dishId": dish_,
        },
      );

      for(final row in result.rows) {
        return row.colByName("count(*)");
      }
      return '0';
    }
    catch(e){
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Container(
                  height: 35,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 20,
                  child: Text(
                    'Cộng đồng',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  height: MediaQuery.of(context).size.height-59-50-20-8,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),

                          for(int i = 0; i < _postList.length; i++)
                            _buildPost(_postList[i]),
                        ],
                      ),
                    )
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }

  Widget _buildPost(PostCard_ pc_) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: profileShadowColor.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.network(
                              pc_._dish.dishImages[0].dishImage == '' ? defaultImage : pc_._dish.dishImages[0].dishImage,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.width * 0.6,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                          decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {

                            },
                            child: Center(
                              child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.favorite_border,
                                  color: inActiveColor,
                                  size: 30,
                                ),
                              )
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.06)),
                                  child: Image.network(
                                    pc_._userLite.userImage == '' ? defaultImage : pc_._userLite.userImage,
                                    width: MediaQuery.of(context).size.width * 0.12,
                                    height: MediaQuery.of(context).size.width * 0.12,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 15,
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //username
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          pc_._userLite.userName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: inActiveColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          " cooked",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color:  defaultTextColor2,
                                            //fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  ),

                                  //foodName
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailDish(
                                            dishTmp: pc_._dish,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      pc_._dish.dishName,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: inActiveColor,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(top: 3, bottom: 3),
                            child: Text(
                              pc_._dish.dishDecription,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: defaultTextColor2,
                              ),
                            ),
                          ),
                        ),
                        //luot like va commnet
                        Container(
                          child: Row(
                            children: [
                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Text(
                                          pc_._collection,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: inActiveColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(Icons.thumb_up_alt_outlined,
                                          color: inActiveColor, size: 15,)
                                      ],
                                    ),
                                  )
                                ),
                                onTap: () {

                                },
                              ),
                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        Text(
                                          pc_._Comment,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: inActiveColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(Icons.comment_outlined,
                                          color: inActiveColor, size: 15,),
                                      ],
                                    ),
                                  )
                                ),
                                onTap: () {

                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

}

class UserLite{
  String _userId;
  String _userName;
  String _userImage;

  UserLite(this._userId, this._userName, this._userImage);

  String get userImage => _userImage;

  set userImage(String value) {
    _userImage = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }
}

class PostCard_{
  Dish _dish;
  UserLite _userLite;
  String _collection;
  String _Comment;

  PostCard_(this._dish, this._userLite, this._collection, this._Comment);

  String get Comment => _Comment;

  set Comment(String value) {
    _Comment = value;
  }

  String get collection => _collection;

  set collection(String value) {
    _collection = value;
  }

  UserLite get userLite => _userLite;

  set userLite(UserLite value) {
    _userLite = value;
  }

  Dish get dish => _dish;

  set dish(Dish value) {
    _dish = value;
  }
}