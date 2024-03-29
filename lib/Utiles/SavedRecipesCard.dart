import 'package:flutter/material.dart';
import 'package:nhonn/Page/DetailDish.dart';
import 'package:nhonn/class/Dish.dart';

class SavedRecipesCard extends StatelessWidget {
  final Dish dish_;
  final double cardWeight;
  const SavedRecipesCard({Key? key, required this.dish_, required this.cardWeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailDish(
              dishTmp: dish_,
            ),
          ),
        );
      },

      child: Container(
        //color: Colors.blue,
        width: cardWeight,
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7), // Độ bo tròn của góc
                child: Image.network(
                  dish_.dishImages[0].dishImage,
                  width: cardWeight - 20,
                  height: cardWeight - 20,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Container(
                height: 50,
                child: Align(
                  alignment: Alignment.centerLeft, // Căn chữ sang trái
                  child: Text(
                    dish_.dishName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}