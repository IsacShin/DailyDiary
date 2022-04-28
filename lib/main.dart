import 'package:dailyapp/Commons/utils.dart';
import 'package:dailyapp/data/data.dart';
import 'package:dailyapp/data/database.dart';
import 'package:dailyapp/views/widget/feedbox.dart';
import 'package:dailyapp/views/write.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  List<Feed> allFeeds = [];
  List<Feed> feeds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistories();
  }

  void getHistories() async {
    allFeeds = await dbHelper.queryAllFeed();
    setState(() {});
  }

  void getDateHistory() async {
    int _d = Utils.getFormatTime(dateTime);
    feeds = await dbHelper.queryFeedByDate(_d);
    print(feeds.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: getPage(),
      floatingActionButton: currentIndex != 0 ? Container() : FloatingActionButton(
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
    }else if(currentIndex == 1) { // calendar
      return getCalendarWidget();
    }

    return Container();
  }

  Widget getHomeWidget() {
    // return FeedBoxWidget();

    return allFeeds.isEmpty ? Container(
      child: const Center(
        child: Text("작성된 피드가 없습니다.\n 오늘의 피드를 작성해주세요.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
      ),
    ) : ListView(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 45),
      children: List.generate(allFeeds.length, (idx){
        return InkWell(
          child:FeedBoxWidget(f: allFeeds[idx],),
          onTap: () async{
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedWritePage(f:allFeeds[idx])),
            );

            getHistories();

          },
        );
      }),
    );
  }

  Widget getHistoryWidget() {
    // return FeedBoxWidget();

    return feeds.isEmpty ? Container(
      height: 300,
      child: const Center(
        child: Text("작성된 피드가 없습니다.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
      ),
    ) : ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // listview > listview in scroll disable
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 45),
      children: List.generate(feeds.length, (idx){
        return InkWell(
          child:FeedBoxWidget(f: feeds[idx],),
          onTap: () async{
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedWritePage(f:feeds[idx])),
            );
            getHistories();
            getDateHistory();
          },
        );
      }),
    );
  }

  Widget getCalendarWidget() {
    return Container(
      child: ListView.builder(itemBuilder: (ctx, idx){
        if(idx == 0) {
          return Container(
              child: TableCalendar(
                firstDay: dateTime.subtract(Duration(days: 365*10 + 2)),
                lastDay: dateTime.add(Duration(days: 365*10 + 2)),
                focusedDay: dateTime,
                selectedDayPredicate: (day) {
                  return isSameDay(dateTime, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  dateTime = selectedDay;
                  getDateHistory();
                },
                headerStyle: HeaderStyle(
                    titleCentered: true
                ),
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: {
                  CalendarFormat.month: ""
                },
              )
          );
        }else if(idx == 1) {
          return getHistoryWidget();
        }

        return Container();
      },
        itemCount: 2,
      ),
    );
  }
}
