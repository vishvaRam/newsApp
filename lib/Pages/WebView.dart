import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:newsapp/Decode/data.dart';

enum isSaved {
  True,
  False
}

class WebtoViewer extends StatefulWidget {
  final List<Data> saved;
  final Data data;
  WebtoViewer(this.data ,this.saved);
  @override
  _WebtoViewerState createState() => _WebtoViewerState();
}

class _WebtoViewerState extends State<WebtoViewer> {
  var temp = isSaved.False;
  bool color = false;

  final emptyWidget = Center(
    child: Text("Empty"),
  );

   void showSnackBar(BuildContext context,String text){
     final snakBar = SnackBar(
      content: Text(text),
       elevation: 9.0,
       backgroundColor: Theme.of(context).accentColor,
     );

     Scaffold.of(context).showSnackBar(snakBar);
  }

  Widget viewer(String url){
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Explore"),),
      body: SafeArea(
        child: widget.data.url == null ? emptyWidget : viewer(widget.data.url),
      ),

      floatingActionButton: Builder(
        builder: (context){
          return FloatingActionButton(
            onPressed: (){

              if(widget.saved.length == 0){
                showSnackBar(context, "Saved to bookmarks");
                setState(() {
                  widget.saved.add(widget.data);
                  color = true;
                });
                return;
              }
              if(widget.saved.length !=0){
                for(int i =0; i< widget.saved.length;i++){
                  if(widget.saved[i].url==widget.data.url){
                    setState(() {
                      temp = isSaved.True;
                    });
                  }
                }

                if(temp == isSaved.True){
                  showSnackBar(context, "Already exist");
                  print("Already exist");
                }
                else{
                  showSnackBar(context, "Saved to bookmarks");
                  print("Add");
                  setState(() {
                    widget.saved.add(widget.data);
                    temp = isSaved.True;
                    color = true;
                  });
                }
              }

            },
            elevation: 8.0,
            backgroundColor: Theme.of(context).accentColor,
            child: color == false ? Icon(Icons.bookmark_border) : Icon(Icons.bookmark),
          );
        },
      ),
    );
  }
}
