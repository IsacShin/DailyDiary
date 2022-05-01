import 'package:dailyapp/Commons/utils.dart';
import 'package:dailyapp/data/data.dart';
import 'package:dailyapp/main.dart';
import 'package:dailyapp/views/write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class FeedBoxWidget extends StatelessWidget {
  final Feed f;
  FeedBoxWidget({Key? key, required this.f}): super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = Utils.stringToDateTime(f.date.toString());

    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            child: AssetThumb(asset: Asset(f.image,"0.jpg",0,0), width: 350, height: 300,),
            borderRadius: BorderRadius.circular(4),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text(f.title, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(f.comment, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),),
                SizedBox(height: 10,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${Utils.makeTwoDigit(dateTime.year)}.${Utils.makeTwoDigit(dateTime.month)}.${dateTime.day}", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal,)),
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage(statusImg[f.status]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
              ],),
          )

        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38,
                spreadRadius: 2,
                blurRadius: 2
            )
          ]
      ),
    );
  }

}
