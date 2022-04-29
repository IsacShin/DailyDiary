import 'package:dailyapp/Commons/utils.dart';
import 'package:dailyapp/data/data.dart';
import 'package:dailyapp/data/database.dart';
import 'package:dailyapp/views/widget/feedbox.dart';
import 'package:dailyapp/views/write.dart';
import 'package:fl_chart/fl_chart.dart';
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
    }else if(currentIndex == 2) { // total
      return getTotalPage();
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
                headerStyle: const HeaderStyle(
                    titleCentered: true
                ),
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {
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

  Widget getTotalPage() {
    double radius = MediaQuery.of(context).size.width / 4.1;

    List<PieChartSectionData> pieChartSectionData = [
      PieChartSectionData(
        value: 20,
        title: '20%',
        color: Color(0xffed733f),
        radius: radius
      ),
      PieChartSectionData(
        value: 35,
        title: '35%',
        color: Color(0xff584f84),
          radius: radius
      ),
      PieChartSectionData(
        value: 15,
        title: '15%',
        color: Color(0xffd86f9b),
          radius: radius
      ),
      PieChartSectionData(
        value: 30,
        title: '30%',
        color: Color(0xffa2663e),
          radius: radius
      ),
    ];

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 0.95 * 0.65,
        padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "기분 통계",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: PieChart(PieChartData(
                      centerSpaceRadius: 0,
                      sectionsSpace: 0,
                      sections: pieChartSectionData
                  ))
                ))
          ],
        ),
      ),
    );

  }
}
