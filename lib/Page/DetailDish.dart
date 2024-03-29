import 'package:flutter/material.dart';
import 'package:nhonn/Page/CommentPage.dart';
import 'package:nhonn/Page/StepPage.dart';
import 'package:nhonn/class/Dish.dart';
import 'package:intl/intl.dart';


import '../Value/color.dart';
import '../Value/image.dart';
import '../class/DishComment.dart';
import '../class/DishImage.dart';
import '../class/DishMaterial.dart';
import '../class/DishStep.dart';
import '../main.dart';

class DetailDish extends StatefulWidget {
  final Dish dishTmp;
  const DetailDish({Key? key, required this.dishTmp}) : super(key: key);

  @override
  State<DetailDish> createState() => _DetailDish();
}

class _DetailDish extends State<DetailDish> {
  bool _isDishLoaded = false;
  bool _isFavor = false;
  bool _isOwner = false;
  int _currentIndex = 0;
  int _currentServing = 1;
  List<DishMaterial> _listMaterial = [];
  List<DishStep> _listSteps = [];
  List<DishComment> _listComments = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData()  async {
    try{
      await _getFavor();
      await _getOwner();
      await _getMaterial();
      await _getStep();
      await _getComment();
      await _setUserHistoryDate();

      setState(() {
        _isDishLoaded = true;
      });
    }
    catch(e){
      print('Có lỗi' + e.toString());
    }
  }

  Future<void> _setUserHistoryDate()  async {
    try{
      var result = await conn.execute(
        "select dishCollectionStatus from DishCollection where userId = :_userId and dishId = :_dishId",
        {
          "_dishId": widget.dishTmp.dishId,
          "_userId": user.userId,
        },
      );

      for(final row in result.rows){
        if(row.colByName("dishCollectionStatus") == null){
          var resultj = await conn.execute(
            "select count(*) from UserHistory  where userId = :_userId and dishId = :_dishId",
            {
              "_dishId": widget.dishTmp.dishId,
              "_userId": user.userId,
            },
          );
          for(final rowj in resultj.rows){
            if(rowj.colByName("count(*)") == '0'){
              await conn.execute(
                "insert into UserHistory(userId, dishId, userHistoryDate) value (:_userId, :_dishId, :_day)",
                {
                  "_dishId": widget.dishTmp.dishId,
                  "_userId": user.userId,
                  "_day": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
                },
              );
            }
            else if(rowj.colByName("count(*)") == '1'){
              await conn.execute(
                "update UserHistory set userHistoryDate = :_day where userId = :_userId and dishId = :_dishId",
                {
                  "_dishId": widget.dishTmp.dishId,
                  "_userId": user.userId,
                  "_day": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
                },
              );
            }
          }
        }
        else if(row.colByName("dishCollectionStatus") == '1'){
          return;
        }
        else if(row.colByName("dishCollectionStatus") == '0'){
          await conn.execute(
            "update UserHistory set userHistoryDate = :_day where userId = :_userId and dishId = :_dishId",
            {
              "_dishId": widget.dishTmp.dishId,
              "_userId": user.userId,
              "_day": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
            },
          );
        }

        break;
      }
    }
    catch(e){
      print('Có lỗi ' + e.toString());
    }
  }

  Future<void> _getComment()  async {
    try{
      var result = await conn.execute(
        "select dc.dishCommentId, dc.userId, u.userName, u.userImage, dc.dishComment, dc.dishCommentDay, " +
          "(select count(*) from DishCommentReac where dc.dishCommentId = dishCommentId and dishCommentStatus = 1) as dishCommentUp, " +
          "(select count(*) from DishCommentReac where dc.dishCommentId = dishCommentId and dishCommentStatus = 0) as dishCommentDown, " +
          "(select dishCommentStatus from DishCommentReac where dc.dishCommentId = dishCommentId and userId = :_userId) as ownerStatus " +
          "from DishComment as dc " +
          "join useraccount as u on dc.userId = u.userId "  +
          "where dc.dishId = :_dishId " +
          "order by dc.dishCommentDay desc ",
        {
          "_dishId": widget.dishTmp.dishId,
          "_userId": user.userId,
        },
      );

      for(final row in result.rows) {
        DishComment _dishCommentTmp = new DishComment(
            row.colByName("dishCommentId") == null ? '' : row.colByName("dishCommentId"),
            row.colByName("userId") == null ? '' : row.colByName("userId"),
            row.colByName("userName") == null ? '' : row.colByName("userName"),
            row.colByName("userImage") == null ? '' : row.colByName("userImage"),
            row.colByName("dishComment") == null ? '' : row.colByName("dishComment"),
            row.colByName("dishCommentDay") == null ? '' : row.colByName("dishCommentDay"),
            row.colByName("dishCommentUp") == null ? '' : row.colByName("dishCommentUp"),
            row.colByName("dishCommentDown") == null ? '' : row.colByName("dishCommentDown"),
            row.colByName("ownerStatus") == null ? '' : row.colByName("ownerStatus"));
        _listComments.add(_dishCommentTmp);
      }
    }
    catch(e){
      print('Có lỗi ' + e.toString());
    }
  }

  Future<void> _getStep()  async {
    try{
      var result = await conn.execute(
        "select dishStepNumber, dishStepImage, dishStepDecription from DishStep where dishId = :_dishId  order by dishStepNumber;",
        {
          "_dishId": widget.dishTmp.dishId,
        },
      );

      for(final row in result.rows) {
        DishStep _dishStepTmp = new DishStep(
            row.colByName("dishStepNumber") == null ? '' : row.colByName("dishStepNumber"),
            row.colByName("dishStepImage") == null ? '' : row.colByName("dishStepImage"),
            row.colByName("dishStepDecription") == null ? '' : row.colByName("dishStepDecription"));
        _listSteps.add(_dishStepTmp);
      }

      DishStep _dishStepTmp = new DishStep(
          (result.numOfRows + 1).toString(),
          '',
          'Nhonn!');
      _listSteps.add(_dishStepTmp);

    }
    catch(e){
      print('Có lỗi ' + e.toString());
    }
  }

  Future<void> _getMaterial()  async {
    try{
      var result = await conn.execute(
        "select dishMaterialName, dishMaterialMass, dishMaterialCalories from DishMaterial where dishId = :_dishId",
        {
          "_dishId": widget.dishTmp.dishId,
        },
      );

      for(final row in result.rows) {
        DishMaterial _dishMaterialTmp = new DishMaterial(
            row.colByName("dishMaterialName") == null ? '' : row.colByName("dishMaterialName"),
            row.colByName("dishMaterialMass") == null ? '' : row.colByName("dishMaterialMass"),
             row.colByName("dishMaterialMass") == null ? '' : row.colByName("dishMaterialMass"));
        _listMaterial.add(_dishMaterialTmp);
      }
    }
    catch(e){
      print('Có lỗi ' + e.toString());
    }
  }

  Future<void> _getFavor()  async {
    try{
      var result = await conn.execute(
        "select count(*) from  DishCollection where userId = :_userId and dishId = :_dishId",
        {
          "_userId": user.userId,
          "_dishId": widget.dishTmp.dishId,
        },
      );

      for(final row in result.rows) {
        row.colByName("count(*)") == '1' ? _isFavor = true : _isFavor = false;
        break;
      }
    }
    catch(e){
      print('Có lỗi ' + e.toString());
    }
  }

  Future<void> _getOwner()  async {
    try{
      var result = await conn.execute(
        "select dishCollectionStatus from  DishCollection where userId = :_userId and dishId = :_dishId",
        {
          "_userId": user.userId,
          "_dishId": widget.dishTmp.dishId,
        },
      );

      for(final row in result.rows) {
        row.colByName("dishCollectionStatus") == '1' ? _isOwner = true : _isOwner = false;
        break;
      }
    }
    catch(e){
      print('Có lỗi ' + e.toString());
    }
  }

  Future<void> _changeFavor()  async {
    if(_isOwner) return;

    try{
      if(_isFavor){
        var result = await conn.execute(
          "delete from DishCollection where userId = :_userId and dishId = :_dishId",
          {
            "_userId": user.userId,
            "_dishId": widget.dishTmp.dishId,
          },
        );
      }
      else{
        var result = await conn.execute(
          "insert into DishCollection(userId, dishId, dishCollectionStatus) value (:_userId, :_dishId, 0)",
          {
            "_userId": user.userId,
            "_dishId": widget.dishTmp.dishId,
          },
        );
      }

      await _getData();

      setState(() {
        _getData();
        _isDishLoaded = true;
      });
    }
    catch(e){
      print('Có lỗi ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
            child: Column(
              children: [
                Container(
                  //color: Colors.blue,
                  height: 60,
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

                      if (_isDishLoaded)
                        Positioned(
                            top: 12,
                            right: 7,
                            child: IconButton(
                              onPressed: () {
                                _changeFavor();
                              },
                              icon: Icon(
                                _isFavor == true ? Icons.favorite : Icons.favorite_border,
                                color: inActiveColor,
                                size: 30,
                              ),
                            )
                        ),
                      if (!_isDishLoaded)
                        Positioned(
                            top: 12,
                            right: 7,
                            child: IconButton(
                              onPressed: () {

                              },
                              icon: Icon(
                                Icons.favorite_border,
                                color: inActiveColor,
                                size: 30,
                              ),
                            )
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
                  child: Column(
                    children: [
                      Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.dishTmp.dishName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 27,

                              ),
                            ),
                          )
                      ),

                      Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.dishTmp.dishDecription,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: defaultTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_outlined,
                                      size: 22,
                                      color: defaultColor2,
                                    ),
                                    Text(
                                      ' Sẵn sàng trong ',
                                      style: TextStyle(
                                        color: defaultTextColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      (double.parse(widget.dishTmp.dishTimePrepare) + double.parse(widget.dishTmp.dishTimeCook)).toString() + " phút",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )
                            )
                        ),
                      ),

                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 10),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      widget.dishTmp.dishImages.isNotEmpty
                                          ? widget.dishTmp.dishImages[_currentIndex].dishImage
                                          : defaultImage,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width - 60,
                                      height: MediaQuery.of(context).size.width - 60,
                                    ),
                                  ),
                                ),
                              ),

                              if(widget.dishTmp.dishImages.length > 1)
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 60,
                                  height: MediaQuery.of(context).size.width - 60,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: (MediaQuery.of(context).size.width - 60) * 0.45,
                                        left: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _currentIndex = _currentIndex > 0 ? _currentIndex - 1 : _currentIndex;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.arrow_back_ios_new_rounded,
                                            color: arrowColors,
                                            size: 30,
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        top: (MediaQuery.of(context).size.width - 60) * 0.45,
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _currentIndex = _currentIndex < (widget.dishTmp.dishImages.length - 1) ? _currentIndex + 1 : _currentIndex;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: arrowColors,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      'Nguyên liêu cho',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child:  Row(
                                        children: [
                                          Text(
                                            _currentServing.toString(),
                                            style: TextStyle(
                                              color: defaultTextColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            ' phần',
                                            style: TextStyle(
                                              color: defaultTextColor,
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: borderDetail,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),

                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _currentServing = _currentServing > 1 ? _currentServing - 1 : _currentServing;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: inActiveColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),

                                  Text(
                                    _currentServing.toString(),
                                    style: TextStyle(
                                      color: defaultTextColor,
                                      fontSize: 15,
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _currentServing += 1;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: inActiveColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Container(
                        child: Column(
                          children: [
                            for(int i = 0; i < _listMaterial.length; i++)
                              Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _listMaterial[i].dishMaterialName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: defaultTextColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            (double.parse(_listMaterial[i].dishMaterialMass) * _currentServing).toString() + ' gam',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: defaultTextColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      color: borderDetail,
                                      height: 2,
                                    ),
                                  ],
                                )
                              ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    'Giá trị dinh dưỡng',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),

                                Container(
                                  child: InkWell(
                                    onTap: (){
                                      print('Chức năng đang được phát triển');
                                    },
                                    child: Text(
                                      'View Info +',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: inActiveColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),

                            SizedBox(
                              height: 15,
                            ),

                            Container(
                              height: 2,
                              color: borderDetail,
                            )
                          ],
                        )
                      ),

                      SizedBox(
                        height: 25,
                      ),

                      Container(
                        child: Column(
                          children: [
                            Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      'Bình luận' ,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: defaultTextColor,
                                      ),
                                    ),

                                    Text(
                                      ' (' + _listComments.length.toString() + ')' ,
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: defaultTextColor2,
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),

                            SizedBox(
                              height: 25,
                            ),

                            if(_isDishLoaded && !_listComments.isEmpty)
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50), // Độ cong của góc
                                          child: Image.network(
                                            _listComments[0].userImage == '' ? defaultImage : _listComments[0].userImage,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context).size.width * 0.15,
                                            height: MediaQuery.of(context).size.width * 0.15,
                                          ),
                                        ),



                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                _listComments[0].userName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: inActiveColor,
                                                ),
                                              ),
                                              Text(
                                                _listComments[0].dishCommentDay,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: defaultTextColor2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _listComments[0].dishComment,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: defaultTextColor2,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),


                            SizedBox(
                              height: 25,
                            ),

                            if(_isDishLoaded && !_listComments.isEmpty)
                              Container(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommentPage(
                                            listComments: _listComments,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Xem tất cả bình luận >',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: inActiveColor,
                                      ),
                                    ),
                                  ),
                                )
                              ),

                            if(_isDishLoaded && _listComments.isEmpty)
                              Container(
                                  child: Center(
                                    child: Text(
                                      'Chưa có bình luận',
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: defaultTextColor2,
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),

                      SizedBox(
                        height: 25,
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: inActiveColor, // Màu viền
                            width: 2, // Độ dày của viền
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        child: InkWell(
                          onTap: (){

                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 12, bottom: 12,),
                            child: Center(
                              child: Text(
                                'Nhonn!',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: inActiveColor,
                                    fontSize: 17
                                ),
                              ),
                            ),
                          ),
                        )
                      ),

                      SizedBox(
                        height: 25,
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              child:  Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Thời gian chuẩn bị',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              )
                            ),

                            SizedBox(
                              height: 25,
                            ),

                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.29,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Thời gian',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 5,
                                        ),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            (double.parse(widget.dishTmp.dishTimeCook) + double.parse(widget.dishTmp.dishTimePrepare)).toString() + " min",
                                            style: TextStyle(
                                              color: defaultTextColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.29,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Chuẩn bị',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 5,
                                        ),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            (double.parse(widget.dishTmp.dishTimePrepare)).toString() + " min",
                                            style: TextStyle(
                                              color: defaultTextColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.29,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Nấu nướng',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          height: 5,
                                        ),

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            (double.parse(widget.dishTmp.dishTimeCook)).toString() + " min",
                                            style: TextStyle(
                                              color: defaultTextColor,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),


                                ],
                              ),
                            ),

                            SizedBox(
                              height: 25,
                            ),

                            Container(
                              decoration: BoxDecoration(
                                color: inActiveColor,
                                border: Border.all(
                                  color: inActiveColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StepPage(
                                          listStep: _listSteps,
                                        ),
                                      ),
                                   );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Text(
                                      'Hướng dẫn từng bước',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: stepModeButtonfont,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 25,
                      ),

                      for(int i = 0; i < _listSteps.length; i++)
                        Container(
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  border: Border.all(
                                    color: backgroundColor,
                                    width: 0,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: profileShadowColor.withOpacity(0.4),
                                      spreadRadius: 0.5,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          _listSteps[i].dishStepNumber,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: defaultTextColor,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: (MediaQuery.of(context).size.width - 20) * 0.8,
                                        child: Text(
                                          _listSteps[i].dishStepDecription,
                                          style: TextStyle(
                                            color: defaultTextColor,
                                            fontSize: 17,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),



                    ],
                  ),
                )
              ],
            )
        ),
      )
    );
  }
}
