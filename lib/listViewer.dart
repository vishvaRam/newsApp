import 'package:flutter/material.dart';
import 'Pages/WebView.dart';
import 'package:newsapp/Decode/data.dart';
import 'package:newsapp/Style.dart';
import 'package:cached_network_image/cached_network_image.dart';


// ignore: must_be_immutable
class ListViewer extends StatefulWidget {
  List<Data> data ;
  List<Data> savedNews ;
  ListViewer(this.data,this.savedNews);
  @override
  _ListViewerState createState() => _ListViewerState();
}

class _ListViewerState extends State<ListViewer> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int i){
        return Padding(
          key: PageStorageKey(widget.data[i].url),
          padding: const EdgeInsets.only(top: 10.0,left: 18.0,right: 18.0),
          child: Container(
            child: InkWell(
              splashColor: Theme.of(context).brightness == Brightness.dark ? Colors.white: Colors.black45,
              onTap: (){
                print("sent to Explorer");
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WebtoViewer(widget.data[i],widget.savedNews)));
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                    child: Container(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0),bottomLeft:Radius.circular(16.0),bottomRight: Radius.circular(16.0) ),
                          child: widget.data[i].urltoimg == null ? Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/img1.jpg'),
                          ) : CachedNetworkImage(fit: BoxFit.cover,imageUrl: widget.data[i].urltoimg,),
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
                            child: Text(widget.data[i].source.name,style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white60 : Colors.black45)),
                          ),
                        ),
                        Text(
                          widget.data[i].title,style: headLineStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
