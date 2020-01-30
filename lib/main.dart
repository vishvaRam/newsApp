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
import 'package:url_launcher/url_launcher.dart';

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

  bool isDark = false;
  List topNews = List<Data>();
  List tech = List<Data>();
  List entertainment = List<Data>();
  List sports = List<Data>();
  List business = List<Data>();
  List science = List<Data>();

  List<Data> saved = List<Data>();

  bool isConnected;

  void showSnackBar(BuildContext context,String text){
    final snakBar = SnackBar(
      content: Text(text,style: TextStyle(fontSize: 18.0),),
      duration: Duration(seconds: 1),
      elevation: 9.0,
      backgroundColor: Theme.of(context).accentColor,
    );

    Scaffold.of(context).showSnackBar(snakBar);
  }


  Widget homePage (BuildContext context){
    return Builder(
      builder: (BuildContext context)=> Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  child: Center(child: Text("Settings",style: TextStyle(fontSize: 44.0,fontWeight: FontWeight.w400),))
              ),
              ListTile(
                title: Text("Dark Theme",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.w400),),
                trailing: Switch(
                  value: isDark,
                  onChanged: (change){
                    setState(() {
                      isDark = change;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text("News API",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.w400)),
                trailing: IconButton(icon: Icon(Icons.open_in_new) , onPressed: () async{
                  final url = "https://newsapi.org/";
                  if(await canLaunch(url)){
                    await launch(url);
                  }
                  else{
                    showSnackBar(context, "Can't open this url");
                  }
                }),
              )
            ],
          ),
        ),

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

        body: DefaultTabController(length: 6,
          child: Scaffold(
            appBar: TabBar(
                indicatorColor: Colors.white,
                labelColor: isDark ? Colors.black87 : Colors.white,
                unselectedLabelColor: isDark ? Colors.white60 : Colors.black45,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    color: isDark ? Colors.tealAccent : Colors.blue
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
      ),
    );
  }



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
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News',
        theme: ThemeData(
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
        home: homePage(context),
      );
  }
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
