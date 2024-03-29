import 'package:flutter/material.dart';

import '../Value/color.dart';
import '../Value/image.dart';
import '../class/DishComment.dart';


class CommentPage extends StatefulWidget {
  final List<DishComment> listComments;
  const CommentPage({Key? key, required this.listComments}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPage();
}

class _CommentPage extends State<CommentPage> {
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

                    Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.18,
                          ),
                          Center(
                            child: Text(
                              widget.listComments.length.toString() + " bình luận",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: defaultTextColor,
                              ),
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),

              for(int i = 0; i < widget.listComments.length; i++)
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50), // Độ cong của góc
                          child: Image.network(
                            widget.listComments[i].userImage == '' ? defaultImage : widget.listComments[i].userImage,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ),

                        SizedBox(
                          width: 20,
                        ),

                        Container(
                          //color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.listComments[i].userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: inActiveColor,
                                ),
                              ),
                              Text(
                                widget.listComments[i].dishCommentDay,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: defaultTextColor3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.listComments[i].dishComment,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: defaultTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.listComments[i].dishCommentUp,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: inActiveColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: (){

                                    },
                                    icon: Icon(
                                      widget.listComments[i].ownerStatus == '1' ? Icons.thumb_up_off_alt_rounded: Icons.thumb_up_off_alt_outlined,
                                      size: 18,
                                      color: inActiveColor,
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),

                                  Text(
                                    widget.listComments[i].dishCommentDown,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: inActiveColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: (){

                                    },
                                    icon: Icon(
                                      widget.listComments[i].ownerStatus == '0' ? Icons.thumb_down_alt: Icons.thumb_down_off_alt_outlined,
                                      size: 18,
                                      color: inActiveColor,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ),

            ],
          ),
        ),
      ),
    );
  }
}
