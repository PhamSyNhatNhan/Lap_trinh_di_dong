import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nhonn/class/DishCategory.dart';
import 'package:nhonn/class/DishStep.dart';

import '../Utiles/SavedRecipesCard.dart';
import '../Value/color.dart';
import '../Value/image.dart';
import '../class/Dish.dart';
import '../class/DishComment.dart';
import '../class/DishImage.dart';
import '../main.dart';

class ListDishPage extends StatefulWidget {
  final DishCategory category_;
  const ListDishPage({Key? key, required this.category_}) : super(key: key);

  @override
  State<ListDishPage> createState() => _ListDishPage();
}

class _ListDishPage extends State<ListDishPage> {
  final List<Dish> _dishList = [];
  bool _isLoaded = false;


  @override
  void initState() {
    super.initState();
    _getDishList();
  }

  Future<void> _getDishList()  async {
    try{
      var result = await conn.execute(
        "select DishCollection.dishId from DishCollection inner join DishCategory where DishCollection.userId = :_userId and DishCollection.dishId = DishCategory.dishId and DishCategory.idCategory = :_idCategory",
        {
          "_userId": user.userId,
          "_idCategory": widget.category_.idCategory
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

          _dishList.add(dish_);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    child: Stack(
                      children: [
                        Positioned(
                            top: 12,
                            left: 7,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: inActiveColor,
                                size: 30,
                              ),
                            )
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      children: [
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 0, left: 10, bottom: 10, right: 10),
                              child: Text(
                                widget.category_.nameCategory,
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: defaultTextColor, // Màu văn bản
                                ),
                              ),
                            )
                          )
                        ),

                        if (_isLoaded)
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
                        if (!_isLoaded)
                          CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
