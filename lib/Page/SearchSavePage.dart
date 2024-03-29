import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:nhonn/Page/DiscoverPage.dart';
import 'package:nhonn/Utiles/SavedRecipesCard.dart';
import 'package:nhonn/Value/color.dart';
import '../class/Dish.dart';
import '../class/DishImage.dart';
import '../main.dart';

class SearchSavePage extends StatefulWidget {
  @override
  State<SearchSavePage> createState() => _SearchSavePage();
}

class _SearchSavePage extends State<SearchSavePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Dish> _searchResult = [];

  Future<void> _searchDishes(String keyword) async {
    try {
      _searchResult.clear();

      if (keyword.isNotEmpty) {
        String query = "select * from Dish where dishName like '%" + keyword + "%' and dishId in (select dishId from DishCollection where userId = '" + user.userId + "')";
        var result = await conn.execute(query);

        for (final row in result.rows) {
          List<DishImage> _listDishImages = [];
          query =
              "select dishImage, dishImageStatus from DishImage where dishId = '" +
                  row.colByName("dishId") +
                  "' order by dishImageStatus desc";
          result = await conn.execute(query);

          for (final rowj in result.rows) {
            DishImage di =
            new DishImage(rowj.colByName("dishImage"), rowj.colByName("dishImageStatus"));
            _listDishImages.add(di);
          }

          Dish dish_ = new Dish(
              row.colByName("dishId"),
              row.colByName("dishName"),
              row.colByName("dishDecription"),
              row.colByName("dishDay"),
              row.colByName("dishTimeCook"),
              row.colByName("dishTimePrepare"),
              row.colByName("dishUp"),
              row.colByName("dishDown"),
              _listDishImages);

          _searchResult.add(dish_);
        }
      }

      setState(() {});
    } catch (e) {
      print('Có lỗi' + e.toString());
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
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      child: InkWell(
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.red,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: defaultColor), // Add border
                        ),
                        child: TextField(
                          autofocus: true,
                          controller: _searchController,
                          onChanged: (value) {
                            _searchDishes(value);
                          },
                          onSubmitted: (value) {
                            _searchDishes(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: hintFont,
                            ),
                            contentPadding: EdgeInsets.only(bottom: 10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height-59-50-20-8,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildFoodList('Kết quả tìm kiếm', _searchResult),
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
    int halfLength = (dishList.length / 2).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cột 1
            Column(
              children: dishList
                  .sublist(0, halfLength)
                  .map((dish) => SavedRecipesCard(
                dish_: dish,
                cardWeight: MediaQuery.of(context).size.width * 0.45,
              ))
                  .toList(),
            ),
            SizedBox(width: 8),
            // Cột 2
            Column(
              children: dishList
                  .sublist(halfLength)
                  .map((dish) => SavedRecipesCard(
                dish_: dish,
                cardWeight: MediaQuery.of(context).size.width * 0.45,
              ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

}
