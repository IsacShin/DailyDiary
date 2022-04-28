import 'package:dailyapp/Commons/utils.dart';
import 'package:dailyapp/data/data.dart';
import 'package:dailyapp/data/database.dart';
import 'package:dailyapp/views/widget/feedbox.dart';
import 'package:dailyapp/views/write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;

  int currentIndex = 0;
  DateTime dateTime = DateTime.now();

  List<Feed> feeds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistories();
  }

  void getHistories() async {
    feeds = await dbHelper.queryAllFeed();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: getPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FeedWritePage(f:Feed(
                date: Utils.getFormatTime(dateTime),
                title: "",
                comment: "",
                image: "",
                status: 0))
            ),
          );

          getHistories();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "피드"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "기록"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.area_chart),
              label: "통계"
          )

        ],
        currentIndex: currentIndex,
        onTap: (idx){
          setState(() {
            currentIndex = idx;
          });
        },
      ),
    );
  }

  Widget getPage() {
    if(currentIndex == 0) { // Home
      return getHomeWidget();
    }

    return Container();
  }

  Widget getHomeWidget() {
    // return FeedBoxWidget();

    return feeds.isEmpty ? Container(
      child: const Center(
        child: Text("작성된 피드가 없습니다.\n 오늘의 피드를 작성해주세요.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
      ),
    ) : ListView(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 45),
      children: List.generate(feeds.length, (idx){
        return InkWell(
          child:FeedBoxWidget(f: feeds[idx],),
          onTap: () async{
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedWritePage(f:feeds[idx])),
            );

            getHistories();
          },
        );
      }),
    );
  }
}
