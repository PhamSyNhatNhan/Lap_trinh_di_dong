import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nhonn/Page/ListDishPage.dart';
import 'package:nhonn/Utiles/SavedRecipesCard.dart';
import 'package:nhonn/Value/image.dart';
import 'package:nhonn/class/DishCategory.dart';

import '../Value/color.dart';
import '../class/Dish.dart';
import '../class/DishImage.dart';
import '../main.dart';

class ActivityMat extends StatefulWidget {
  @override
  State<ActivityMat> createState() => _ActivityMat();
}

class _ActivityMat extends State<ActivityMat> {
  final List<Dish> _dishListOwner = [];
  final List<Dish> _dishListHistory = [];
  bool _isLoaded = false;


  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData()  async {
    try{
      await _getDishList();
      await _getHistory();

      setState(() {
        _isLoaded = true;
      });
    }
    catch(e){
      print('Có lỗi' + e.toString());
    }
  }

  Future<void> _getDishList()  async {
    try{
      var result = await conn.execute(
        "select Dish.dishId from Dish inner join DishCollection where DishCollection.dishId = Dish.dishId and dishCollectionStatus = 1 and DishCollection.userId = :_userId",
        {
          "_userId": user.userId,
        },
      );

      for (final row in result.rows){
        List<DishImage> _listDishImages = [];
        var resultj = await conn.execute(
          "select dishImage, dishImageStatus from DishImage where dishId = :_dishId order by dishImageStatus desc",
          {
            "_dishId": row.colByName("dishId")
          },
        );

        for(final rowj in resultj.rows) {
          DishImage di = new DishImage(rowj.colByName("dishImage"), rowj.colByName("dishImageStatus"));
          _listDishImages.add(di);
        }

        resultj = await conn.execute(
          "select * from Dish where dishId = :_dishId",
          {
            "_dishId": row.colByName("dishId")
          },
        );

        for(final rowj in resultj.rows) {
          Dish dish_ = new Dish(rowj.colByName("dishId"),
              rowj.colByName("dishName"),
              rowj.colByName("dishDecription"),
              rowj.colByName("dishDay"),
              rowj.colByName("dishTimeCook"),
              rowj.colByName("dishTimePrepare"),
              rowj.colByName("dishUp"),
              rowj.colByName("dishDown"),
              _listDishImages);

          _dishListOwner.add(dish_);
          break;
        }
      }
    }
    catch(e){
      print('Có lỗi' + e.toString());
    }
  }

  Future<void> _getHistory()  async {
    try{
      var result = await conn.execute(
        "select dishId from UserHistory where userId = :_userId order by userHistoryDate desc",
        {
          "_userId": user.userId,
        },
      );

      for (final row in result.rows){
        List<DishImage> _listDishImages = [];
        var resultj = await conn.execute(
          "select dishImage, dishImageStatus from DishImage where dishId = :_dishId order by dishImageStatus desc",
          {
            "_dishId": row.colByName("dishId")
          },
        );

        for(final rowj in resultj.rows) {
          DishImage di = new DishImage(rowj.colByName("dishImage"), rowj.colByName("dishImageStatus"));
          _listDishImages.add(di);
        }

        resultj = await conn.execute(
          "select * from Dish where dishId = :_dishId",
          {
            "_dishId": row.colByName("dishId")
          },
        );

        for(final rowj in resultj.rows) {
          Dish dish_ = new Dish(rowj.colByName("dishId"),
              rowj.colByName("dishName"),
              rowj.colByName("dishDecription"),
              rowj.colByName("dishDay"),
              rowj.colByName("dishTimeCook"),
              rowj.colByName("dishTimePrepare"),
              rowj.colByName("dishUp"),
              rowj.colByName("dishDown"),
              _listDishImages);

          _dishListHistory.add(dish_);
          break;
        }
      }
    }
    catch(e){
      print('Có lỗi' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
      child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bình luận',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: defaultColor, // Màu văn bản
                    ),
                  ),
                ),
              ),
            ),

            Container(
              height: 100,
              child: Center(
                child:  Text(
                  'Tính năng đang được phát triển',
                  style: TextStyle(
                    fontSize: 17,
                    //fontWeight: FontWeight.bold,
                    color: defaultColor, // Màu văn bản
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 25,
            ),

            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Công thức',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: defaultColor, // Màu văn bản
                    ),
                  ),
                ),
              ),
            ),

            if(_isLoaded)
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for(int i = 0; i < _dishListOwner.length; i++)
                          SavedRecipesCard(
                            dish_: _dishListOwner[i], cardWeight: MediaQuery.of(context).size.width * 0.4
                          )
                      ],
                    ),
                  ),
                )
              ),

            SizedBox(
              height: 25,
            ),

            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lịch sử',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: defaultColor, // Màu văn bản
                    ),
                  ),
                ),
              ),
            ),

            if(_isLoaded)
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for(int i = 0; i < _dishListHistory.length; i++)
                          SavedRecipesCard(
                              dish_: _dishListHistory[i], cardWeight: MediaQuery.of(context).size.width * 0.4
                          )
                      ],
                    ),
                  ),
                )
              ),
        ]
      ),
    );
  }
}

