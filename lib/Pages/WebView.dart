import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:newsapp/Decode/data.dart';
import '../Functionality/database.dart';
import 'package:newsapp/Functionality/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

enum isSaved {
  True,
  False
}

class WebtoViewer extends StatefulWidget {
  List<Data> savedList = List<Data>();
  final Data data;
  WebtoViewer(this.data,this.savedList);
  @override
  _WebtoViewerState createState() => _WebtoViewerState();
}

class _WebtoViewerState extends State<WebtoViewer> {
  var temp = isSaved.False;
  bool isLoading;

  // Singletone class
  final dB = DatabaseHelper.instance;

  @override
  void initState() {
    setState(() {
      isLoading =true;
    });
    super.initState();
  }

  final emptyWidget = Center(
    child: Text("Empty"),
  );

  void showSnackBar(BuildContext context,String text){
     final snakBar = SnackBar(
      content: Text(text,style: TextStyle(fontSize: 18.0),),
       duration: Duration(seconds: 1),
       elevation: 9.0,
       backgroundColor: Theme.of(context).accentColor,
     );

     Scaffold.of(context).showSnackBar(snakBar);
  }

  Widget viewer(String url){
    return Stack(children: <Widget>[
      WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (_){
          setState(() {
            isLoading = false;
          });
        },
      ),
      isLoading ? Container(
        alignment: FractionalOffset.center,
        child: CircularProgressIndicator(),
      ): Container(),
    ],);
  }

  Future<List<Data>> getDataFromDB() async{
    try{
      var result = await dB.queryAllRows();
      if(result != null){
        return result;
      }
    }catch(NoSuchMethod){
      print('Emp');
    }
  }

  Widget floatingActionButton (){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Builder(
              builder: (context){
                return FloatingActionButton(
                  heroTag: "FAB1",
                  onPressed: () async{
                    print("to Save");
                    showSnackBar(context, "Saved");
                    var sa =await dB.insert(widget.data);
                    print(sa);
                    var res = await getDataFromDB();
                    setState(() {
                      widget.savedList = res;
                    });

          //              if(widget.savedList.length == 0){
          //                showSnackBar(context, "Saved first element");
          //                var sa =await dB.insert(widget.data);
          //                print(sa);
          //                var res = await getDataFromDB();
          //                print("result from DB = "+res.toString());
          //                widget.savedList = res;
          //                return;
          //              }
          //              if(widget.savedList.length !=0){
          //                print("not empty");
          //                for(int i =0; i< widget.savedList.length;i++){
          //                  print(widget.savedList[i].url.toString());
          //                  if(widget.savedList[i].url==widget.data.url){
          //                      temp = isSaved.True;
          //                  }
          //                }
          //
          //                if(temp == isSaved.True){
          //                  showSnackBar(context, "Already exist");
          //                  print("Already exist");
          //                }
          //                else{
          //                  temp = isSaved.True;
          //                  showSnackBar(context, "Saved to bookmarks");
          //                  print("Add");
          //                  await dB.insert(widget.data);
          //                  var res = await getDataFromDB();
          //                  widget.savedList = res;
          //                }
          //              }
                    },
                      elevation: 20.0,
                      backgroundColor: Theme.of(context).accentColor,
                      child: Icon(Icons.add),
                    );
                },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Builder(
            builder: (context){
              return FloatingActionButton(
                heroTag: "share",
                onPressed: () {
                  Share.share(widget.data.url,subject: widget.data.title);
                },
                elevation: 20.0,
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(Icons.share),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Builder(
              builder:(BuildContext context){
                return FloatingActionButton.extended(
                  heroTag: "FAB2",
                  elevation: 20.0,
                  onPressed: () async {
                    String url = widget.data.url;
                    if(await canLaunch(url)){
                      await launch(url);
                    }else{
                      throw "Could not launch "+ widget.data.url;
                    }
                  },
                  label: Text(" Open with brower"),
                );
              }
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explore"),),
      body: SafeArea(
        child: widget.data.url == null ? emptyWidget : viewer(widget.data.url),
      ),
      floatingActionButton: floatingActionButton()
      );
  }

}
