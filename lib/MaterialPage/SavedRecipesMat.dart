import 'package:flutter/material.dart';
import 'package:nhonn/Page/SearchSavePage.dart';
import 'package:nhonn/class/DishImage.dart';

import '../Page/SearchPage.dart';
import '../Utiles/SavedRecipesCard.dart';
import '../Value/color.dart';
import '../class/Dish.dart';
import '../main.dart';

class SavedRecipesMat extends StatefulWidget {
  @override
  State<SavedRecipesMat> createState() => _SavedRecipesMat();
}

class _SavedRecipesMat extends State<SavedRecipesMat> {
  final List<Dish> _dishList = [];
  bool _isDishListLoaded = false;


  @override
  void initState() {
    super.initState();
    _getDishList();
  }

  Future<void> _getDishList()  async {
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

          _dishList.add(dish_);
          break;
        }
      }

      setState(() {
        _isDishListLoaded = true;
      });
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
          SizedBox(
            height: 10,
          ),

          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: defaultColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchSavePage(),
                  ),
                );
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 7,
                    left: 10,
                    child: Icon(
                      Icons.search_outlined,
                      color: hintFont,
                      size: 23,
                    ),
                  ),

                  SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 1.0,
                    child: Center(
                      child: Text(
                        'Tìm kiếm công thức đã lưu',
                        style: TextStyle(
                          fontSize: 14,
                          //fontWeight: FontWeight.bold,
                          color: hintFont, // Màu văn bản
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),

          if (_isDishListLoaded)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < _dishList.length; i+=2)
                        SavedRecipesCard(
                          dish_: _dishList[i],
                          cardWeight: MediaQuery.of(context).size.width * 0.42,
                        ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var i = 1; i < _dishList.length; i+=2)
                        SavedRecipesCard(
                          dish_: _dishList[i],
                          cardWeight: MediaQuery.of(context).size.width * 0.42,
                        ),
                    ],
                  ),
                )
              ],
            ),
          if (!_isDishListLoaded)
            CircularProgressIndicator(),
        ],
      ),
    );
  }
}