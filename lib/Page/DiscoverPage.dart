import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

import 'package:nhonn/Page/SearchPage.dart';

import '../Value/color.dart';
import '../class/Dish.dart';
import '../class/DishImage.dart';
import '../main.dart';
import 'DetailDish.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPage();
}

class _DiscoverPage extends State<DiscoverPage> {
  final List<Dish> _dishList = [];
  bool _isDishListLoaded = false;


  @override
  void initState() {
    super.initState();
    _getDishList();
  }

  Future<void> _getDishList()  async {
    try{
      String query = "SELECT Dish.dishId, DishImage.dishImage, Dish.dishName FROM Dish INNER JOIN DishImage ON Dish.dishId = DishImage.dishId";
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
    return Scaffold(
      body:Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children:[
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
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
                            builder: (context) => SearchPage(),
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
                              color: defaultTextColor3,
                              size: 23,
                            ),
                          ),
                          SizedBox(
                            height: 35,
                            width: MediaQuery.of(context).size.width - 10,
                            child: Center(
                              child: Text(
                                'Tìm kiếm',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: hintFont,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  height: MediaQuery.of(context).size.height-59-50-20-8,

                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFoodList('Xu hướng', _dishList),
                        _buildFoodList('Đề xuất', _dishList),
                        _buildFoodList2('Gần đây', _dishList),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList(String title, List<Dish> dishList) {
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),
          Container(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dishList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: _buildFoodCard(dishList[index]),
                );
              },
            ),
          ),
        ],

      ),
    );
  }

  Widget _buildFoodList2(String title, List<Dish> dishList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(
          height: 20,
        ),

        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.43,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < _dishList.length; i+=2)
                        _buildFoodCard(dishList[i]),
                    ],
                  ),
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.43,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var i = 1; i < _dishList.length; i+=2)
                        _buildFoodCard(dishList[i]),
                    ],
                  ),
                )
              )
            ],
          ),

        ),
      ],
    );
  }


  Widget _buildFoodCard(Dish dishTmp) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDish(
              dishTmp: dishTmp,
            ),
          ),
        );
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  height: 150,
                  dishTmp.dishImages[0].dishImage,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(
              height: 5,
            ),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dishTmp.dishName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Prep Time: " + dishTmp.dishTimePrepare + " mins ",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Icon(Icons.access_time, size: 12, color: Colors.grey),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Cooking Time:" + dishTmp.dishTimeCook + " mins ",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Icon(Icons.access_time, size: 12, color: Colors.grey),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
