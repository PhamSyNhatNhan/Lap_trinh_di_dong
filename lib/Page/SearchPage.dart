import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:nhonn/Page/DiscoverPage.dart';
import 'package:nhonn/Value/color.dart';
import '../class/Dish.dart';
import '../class/DishImage.dart';
import '../main.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  DiscoverPage _discoverPage = DiscoverPage();
  final TextEditingController _searchController = TextEditingController();
  List<Dish> _searchResult = [];

  Future<void> _searchDishes(String keyword) async {
    try {
      _searchResult.clear();

      if (keyword.isNotEmpty) {
        String query = "SELECT * FROM Dish WHERE dishName LIKE '%$keyword%'";
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
                        child: Icon(Icons.close, size: 30, color: Colors.red,),
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
                            hintText: 'Search Tasty',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            hintStyle: TextStyle(
                              fontSize: 15, // Thay đổi kích thước của chữ hint
                              color: hintFont, // Thay đổi màu sắc của chữ hint
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
                        _buildFoodList2('Search Results', _searchResult),
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

  Widget _buildFoodList2(String title, List<Dish> dishList) {
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
        Column(
          children: dishList.map((dish) => _buildFoodCard(dish)).toList(),
        ),
      ],
    );
  }

  Widget _buildFoodCard(Dish dish) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                dish.dishImages.isNotEmpty ? dish.dishImages.first.dishImage : '',
                height: 150,
                width: MediaQuery.of(context).size.width - 32,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              dish.dishName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Prep Time: ${dish.dishTimePrepare} mins',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Icon(Icons.access_time, size: 16, color: Colors.grey),
              ],
            ),
            Row(
              children: [
                Text(
                  'Cooking Time: ${dish.dishTimeCook} mins',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Icon(Icons.access_time, size: 16, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
