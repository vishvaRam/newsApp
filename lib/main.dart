import 'dart:ui';
import 'package:flutter/material.dart';

import 'Style.dart';
import 'Functionality/Networking.dart';
import 'package:newsapp/Decode/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/rendering.dart';
import 'Pages/WebView.dart';
import 'package:newsapp/Pages/Saved.dart';


void main() {
  runApp(MyApp());
}

const String Country = "us";
const int pageSize = 40;
const String ApiKey = "&apiKey=318936fec83d46d0b6fb17784fe63c32";
var uRL = "https://newsapi.org/v2/top-headlines?country="+Country+"&pageSize="+pageSize.toString()+ApiKey;

class MyApp extends StatelessWidget {
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

class _MyHomePageState extends State<MyHomePage> {
  List topNews = List<Data>();
  List savedNews = List<Data>();


  @override
  void initState() {
    super.initState();

    print("Saved Data = "+ savedNews.length.toString());
    Networking net = Networking(uRL);
    net.output().then((data){
      setState(() {
        topNews.addAll(data);
      });
    });
  }

  Widget listBuilder (dynamic data){
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int i){
        return Padding(
          key: Key(data[i].title),
          padding: const EdgeInsets.only(top: 10.0,left: 18.0,right: 18.0),
          child: GestureDetector(
            onTap: (){
              print("sent to Explorer");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>WebtoViewer(data[i],savedNews)));
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  child: Container(
                      height: 170,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0),bottomLeft:Radius.circular(16.0),bottomRight: Radius.circular(16.0) ),
                        child: data[i].urltoimg == null ? Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/img1.jpg'),
                        ) : Image(
                            fit: BoxFit.cover,image: NetworkImage(data[i].urltoimg)
                        ),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0,top: 5.0),
                          child: Text(data[i].source.name,style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black45)),
                        ),
                      ),
                      Text(
                        data[i].title,style: headLineStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget spinner = Center(
    child: SpinKitDoubleBounce(
      size: 70.0,
      color: Colors.blue,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
//                print("Length =="+savedNews.length.toString());
//                for(var i=0;i<=savedNews.length;i++){
//                  print(i.toString()+"=="+savedNews[i].url);
//                }
              }
              else{
                print("Empty!");
              }
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 90.0,
              child: topNews.length == 0 ? spinner : listBuilder(topNews)
          ),
        ],
      ),
    );
  }
}
