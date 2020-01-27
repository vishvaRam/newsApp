import 'dart:ui';
import 'package:flutter/material.dart';
import 'Functionality/Networking.dart';
import 'package:newsapp/Decode/data.dart';
import 'package:flutter/rendering.dart';
import 'package:newsapp/Pages/Saved.dart';
import 'listViewer.dart';


void main() {
  runApp(MyApp());
}

const String Country = "in";
const String ApiKey = "&apiKey=318936fec83d46d0b6fb17784fe63c32";
const String rawUrl = "https://newsapi.org/v2/top-headlines?pageSize=50&country=";
const String all = rawUrl+Country+ApiKey;
const String category= "&category=";
var technology = rawUrl + Country+category+"technology"+ApiKey;
var entertain = rawUrl + Country+category+"entertainment"+ApiKey;
var sport = rawUrl + Country+category+"sports"+ApiKey;
var bussi = rawUrl + Country+category+"business"+ApiKey;
var sc = rawUrl + Country+category+"science"+ApiKey;



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin{

  List topNews = List<Data>();
  List savedNews = List<Data>();
  List tech = List<Data>();
  List entertainment = List<Data>();
  List sports = List<Data>();
  List business = List<Data>();
  List science = List<Data>();

  @override
  void initState() {
    super.initState();

    Networking net = Networking();
    net.output(all).then((data){
      setState(() {
        topNews.addAll(data);
      });
    });
    net.output(technology).then((q){
      setState(() {
        tech.addAll(q);
      });
    });

    net.output(entertain).then((data){
      setState(() {
        entertainment.addAll(data);
      });
    });

    net.output(sport).then((data){
      setState(() {
        sports.addAll(data);
      });

    });
    net.output(bussi).then((data){
      setState(() {
        business.addAll(data);
      });
    });
    net.output(sc).then((data){
      setState(() {
        science.addAll(data);
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
//      drawer: Drawer(
//        child: ,
//        ),

      appBar: AppBar(
        centerTitle: true,
        title: Text("News"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: (){
              print("icon btn");
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=> SavedNews(savedNews)
              ));
              if(savedNews.length!=0){
                print(savedNews.length.toString());
              }
              else{
                print("Empty!");
              }
            },
          )
        ],
      ),

      //topNews.length == 0 ? spinner : listBuilder(topNews)

      body: DefaultTabController(length: 6,
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: Colors.black,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              color: Theme.of(context).primaryColorLight
            ),
            isScrollable: true,
              tabs: [
            Tab(text: "All",),
            Tab(text: "Tech",),
            Tab(text: "Entertainment",),
            Tab(text: "Sports",),
            Tab(text: "business",),
            Tab(text: "Science",),
          ]),
          body: TabBarView(
              children: <Widget>[
            topNews.length == 0 ? Center(child: CircularProgressIndicator(),): ListViewer(topNews,savedNews),
            topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(tech,savedNews),
            topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(entertainment,savedNews),
            topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(sports,savedNews),
            topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(business,savedNews),
            topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(science,savedNews),
          ]),
        ),),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
