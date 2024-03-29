import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nhonn/Page/ListDishPage.dart';
import 'package:nhonn/Value/image.dart';
import 'package:nhonn/class/DishCategory.dart';

import '../Value/color.dart';
import '../main.dart';

class CookbookMat extends StatefulWidget {
  @override
  State<CookbookMat> createState() => _CookbookMat();
}

class _CookbookMat extends State<CookbookMat> {
  final List<DishCategory> _listCate = [];
  bool _isLoaded = false;


  @override
  void initState() {
    super.initState();
    _getCateList();
  }

  Future<void> _getCateList()  async {
    try{
      var result = await conn.execute(
        "select idCategory, nameCategory, " +
        "(select count(*) from DishCollection inner join DishCategory where DishCollection.userId = :_userId and DishCollection.dishId = DishCategory.dishId and Category.idCategory = DishCategory.idCategory) as dishNumber " +
        "from Category order by idCategory",
        {
          "_userId": user.userId,
        },
      );

      for(final row in result.rows) {
        DishCategory _dishCateTmp = new DishCategory(
            row.colByName("idCategory") == null ? '' : row.colByName("idCategory"),
            row.colByName("nameCategory") == null ? '' : row.colByName("nameCategory"),
            row.colByName("dishNumber") == null ? '' : row.colByName("dishNumber"),
            ''
        );

        var resultj = await conn.execute(
          "select dishImage from DishImage inner join DishCollection inner join DishCategory where " +
          "DishCollection.userId = :_userId and " +
          "DishImage.dishId = DishCollection.dishId and " +
          "DishCategory.dishId = DishImage.dishId and " +
          "DishImage.dishImageStatus = 1 and " +
          "DishCategory.idCategory = :_idCategory",
          {
            "_userId": user.userId,
            "_idCategory": row.colByName("idCategory")
          },
        );

        for(final rowj in resultj.rows){
          rowj.colByName("dishImage") == null ? _dishCateTmp.cateImage = '' : _dishCateTmp.cateImage = rowj.colByName("dishImage");
          break;
        }

        _listCate.add(_dishCateTmp);
      }

      setState(() {
        _isLoaded = true;
      });
    }
    catch(e){
      print('Có lỗi ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          if(_isLoaded)
            for(var i = 0; i < _listCate.length; i++)
              Container(
                child: InkWell(
                  onTap: (){
                    if(int.parse(_listCate[i].dishNumber) > 0)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListDishPage(
                            category_: _listCate[i],
                          ),
                        ),
                      );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 0, right: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            _listCate[i].cateImage == '' ? defaultImage : _listCate[i].cateImage,
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.width * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(
                          width: 20,
                        ),

                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _listCate[i].nameCategory,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: defaultTextColor,
                                  fontSize: 17,
                                ),
                              ),

                              Text(
                                _listCate[i].dishNumber + " công thức",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: defaultTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
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