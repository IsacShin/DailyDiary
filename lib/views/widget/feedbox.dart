import 'package:dailyapp/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedBoxWidget extends StatelessWidget {
  final Feed? f;
  FeedBoxWidget({Key? key, this.f}): super(key: key);

  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Image.asset("assets/img/test.jpg", fit: BoxFit.fill,),
            borderRadius: BorderRadius.circular(4),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text("오늘은 놀러갔던 날\n오늘은 놀러갔던 날오늘은 놀러갔던 날오늘은 놀러갔던 날오늘은 놀러갔던 날오늘은 놀러갔던 날", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text("오늘은 놀러갔던 날", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal),),
                SizedBox(height: 10,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${dateTime.year}.${dateTime.month}.${dateTime.day}.${dateTime.hour}.${dateTime.minute}", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal,)),
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage("assets/img/test.jpg"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
              ],),
          )

        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.blueGrey,
                spreadRadius: 4,
                blurRadius: 4
            )
          ]
      ),
    );
  }

}