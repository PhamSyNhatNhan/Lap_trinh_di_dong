import 'package:flutter/material.dart';

import '../Value/color.dart';
import '../Value/image.dart';
import '../class/DishComment.dart';


class UploadPage extends StatefulWidget {

  @override
  State<UploadPage> createState() => _UploadPage();
}

class _UploadPage extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Text(
                    'Tính năng đang được phát triển',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: defaultTextColor,
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
