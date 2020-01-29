import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'Functionality/Networking.dart';
import 'package:newsapp/Decode/data.dart';
import 'package:flutter/rendering.dart';
import 'package:newsapp/Pages/Saved.dart';
import 'package:connectivity/connectivity.dart';
import 'package:newsapp/Functionality/database.dart';
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

// Singelton class instance
final dB = DatabaseHelper.instance;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News',
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
  List tech = List<Data>();
  List entertainment = List<Data>();
  List sports = List<Data>();
  List business = List<Data>();
  List science = List<Data>();

  List<Data> saved = List<Data>();

  bool isConnected;

  @override
  void initState() {
    super.initState();
    // Connection Checking
    getConnection();

    // get Saved List if there is!
    getDataFromDB();

    Networking net = Networking();
    net.output(all).then((data){
      if(data != null){
        setState(() {
          topNews.addAll(data);
        });
      }
    }).catchError((err){
      print("Printed ==="+err);
    });

    net.output(technology).then((q){
      if(q !=null){
        setState(() {
          tech.addAll(q);
        });
      }
    }).catchError((err){
      print("Printed ==="+err);
    });

    net.output(entertain).then((data){
      if(data != null){
        setState(() {
          entertainment.addAll(data);
        });
      }
    }).catchError((err){
      print("Printed ==="+err);
    });

    net.output(sport).then((data){
      if(data != null){
        setState(() {
          sports.addAll(data);
        });
      }
    }).catchError((err){
      print("Printed ==="+err);
    });

    net.output(bussi).then((data){
      if(data != null){
        setState(() {
          business.addAll(data);
        });
      }
    }).catchError((err){
      print("Printed ==="+err);
    });

    net.output(sc).then((data){
      if(data != null){
        setState(() {
          science.addAll(data);
        });
      }
    }).catchError((err){
      print("Printed ==="+err);
    })
    ;
  }

  getDataFromDB() async{
    try{
      var result = await dB.queryAllRows();
      if(result != null){
        setState(() {
          saved = result;
        });
      }
      if(saved != null){
        for(int i=0 ; i<result.length;i++){
          print(result[i].url);
        }
      }
    }catch(NoSuchMethod){
      print('Emp');
    }
  }

  getConnection() async{
    bool sta = await status();
    if(sta){
      setState(() {
        isConnected = true;
      });
    }
    else {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    // Over ride the class to stay where we are on the page
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("News"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=> SavedNews(saved)
              ));
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
            Container(child: isConnected == true ? topNews.length == 0 ? Center(child: CircularProgressIndicator(),): ListViewer(topNews,saved): Center(child: Text("Connect to internet and restart the app"),),),
            Container(child: isConnected == true ? topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(tech,saved): Center(child: Text("Connect to internet and restart the app"),),),
            Container(child: isConnected == true ? topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(entertainment,saved): Center(child: Text("Connect to internet and restart the app"),),),
            Container(child: isConnected == true ? topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(sports,saved): Center(child: Text("Connect to internet and restart the app"),),),
            Container(child: isConnected == true ? topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(business,saved): Center(child: Text("Connect to internet and restart the app"),),),
            Container(child: isConnected == true ? topNews.length == 0 ? Center(child: CircularProgressIndicator(),) : ListViewer(science,saved): Center(child: Text("Connect to internet and restart the app"),),),
          ]),
        ),),
    );
  }

  // Set State on Connect to internet
  Future<bool> status() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    else{
      return false;
    }
  }

  // To Keep Alive the page
  @override
  bool get wantKeepAlive => true;

}


