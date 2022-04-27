import 'package:dailyapp/Commons/utils.dart';
import 'package:dailyapp/data/data.dart';
import 'package:dailyapp/data/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class FeedWritePage extends StatefulWidget {
  final Feed f;
  const FeedWritePage({Key? key, required this.f}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FeedWritePageState();
  }
}

class _FeedWritePageState extends State<FeedWritePage> {
  DateTime dateTime = DateTime.now();
  Feed get feed => widget.f;

  TextEditingController titleController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  int selectIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = feed.title;
    commentController.text = feed.comment;
    selectIndex = feed.status;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () async {
                if(feed.image.isEmpty &&
                      titleController.text.isEmpty &&
                        commentController.text.isEmpty) {
                  showAlertDialog(context);
                  return;
                }
                final db = DatabaseHelper.instance;
                feed.title = titleController.text;
                feed.comment = commentController.text;
                await db.insertFeed(feed);
                Navigator.of(context).pop();
              },
              child: Text("저장", style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: ListView.builder(itemBuilder: (ctx, idx){
        if(idx == 0) { // 이미지 업로드
          return Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            height: 150,
            width: 150,
            child: InkWell(
              child: AspectRatio(
                child:Align(child:feed.image.isEmpty ?
                Container(
                  color: Colors.blueGrey,
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/img/plus.png"),
                ) :
                AssetThumb(asset: Asset(feed.image,"img_${Utils.getFormatTime(dateTime)}.jpg",0,0),
                  width: 150, height: 150,),
                ),
                aspectRatio: 1/1,
              ),
              onTap: (){
                selectImage();
              },
            ),
          );
        } else if(idx == 1) { // 타이틀
          return Column(children: [
            Text("제목을 입력해주세요."),
            Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                height: 80,
                child: TextField(
                  maxLines: 10,
                  minLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueGrey, width: 0.5)
                      )
                  ),
                  controller: titleController,
                )
            )
          ],);
        } else if(idx == 2) { // 커멘트
          return Column(children: [
            Text("오늘의 코멘트를 남겨주세요."),
            Container(
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: TextField(
                  maxLines: 10,
                  minLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueGrey, width: 0.5)
                      )
                  ),
                  controller: commentController,
                )
            )
          ],);
        } else if(idx == 3) { // 기분상태
          return Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child:Column(
            children: [
              Text("오늘의 기분은?"),
              SizedBox(height: 12,),
              Container(
              child: Row(
                  children: [
                    InkWell(
                      child: Container(
                        color: selectIndex == 0 ? Colors.blueGrey : Colors.white,
                        width: 70,
                        height: 70,
                        child: Image.asset("assets/img/happy.png"),
                      ),
                      onTap: (){
                        setState(() {
                          selectIndex = 0;
                          feed.status = selectIndex;
                        });
                      },
                    ),
                    Spacer(),
                    InkWell(
                      child: Container(
                        color: selectIndex == 1 ? Colors.blueGrey : Colors.white,
                        width: 70,
                        height: 70,
                        child: Image.asset("assets/img/soso.png"),
                      ),
                      onTap: (){
                        setState(() {
                          selectIndex = 1;
                          feed.status = selectIndex;
                        });
                      },
                    ),
                    Spacer(),
                    InkWell(
                      child: Container(
                        color: selectIndex == 2 ? Colors.blueGrey : Colors.white,
                        width: 70,
                        height: 70,
                        child: Image.asset("assets/img/sad.png"),
                      ),
                      onTap: (){
                        setState(() {
                          selectIndex = 2;
                          feed.status = selectIndex;
                        });
                      },
                    ),
                    Spacer(),
                    InkWell(
                      child: Container(
                        color: selectIndex == 3 ? Colors.blueGrey : Colors.white,
                        width: 70,
                        height: 70,
                        child: Image.asset("assets/img/angry.png"),
                      ),
                      onTap: (){
                        setState(() {
                          selectIndex = 3;
                          feed.status = selectIndex;
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          ));
        }
        return Container();
      },
      itemCount: 4,),
    );
  }

  Future<void> selectImage() async {
    try{
      List<Asset> resultList = <Asset>[];
      resultList =
      await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      );
      if (resultList.length < 1) {
        return;
      }
      setState(() {
        feed.image = resultList.first.identifier!;
      });
    }catch(error) {
      print(error);
      return;
    }
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text("미입력한 항목을 체크해주세요.", textAlign: TextAlign.center,),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "확인");
              },
            ),
          ],
        );
      },
    );
  }
}

