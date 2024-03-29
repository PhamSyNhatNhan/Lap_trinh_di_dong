import 'package:flutter/material.dart';
import 'package:nhonn/class/DishStep.dart';

import '../Value/color.dart';
import '../Value/image.dart';
import '../class/DishComment.dart';

class StepPage extends StatefulWidget {
  final List<DishStep> listStep;
  const StepPage({Key? key, required this.listStep}) : super(key: key);

  @override
  State<StepPage> createState() => _StepPage();
}

class _StepPage extends State<StepPage> {
  int _currentPage = 0;

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
                    child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 20, bottom: 0, right: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          (_currentPage + 1).toString() + " of " + widget.listStep.length.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: defaultTextColor,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    )
                ),

                Container(
                  height: MediaQuery.of(context).size.height - 95,
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if(widget.listStep[_currentPage].dishStepImage != '')
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network(
                                  widget.listStep[_currentPage].dishStepImage,
                                  width: MediaQuery.of(context).size.width * 0.89,
                                  height: MediaQuery.of(context).size.width * 0.89,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(top: 0, left: 20, bottom: 0, right: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.listStep[_currentPage].dishStepDecription,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: defaultTextColor,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            )
                          )
                        ],
                      ),

                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _currentPage = (_currentPage - 1).clamp(0, widget.listStep.length - 1);
                                  });
                                },
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                              ),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _currentPage = (_currentPage + 1).clamp(0, widget.listStep.length - 1);
                                  });
                                },
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
