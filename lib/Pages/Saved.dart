import 'package:flutter/material.dart';
import 'package:newsapp/Decode/data.dart';
import 'WebView.dart';

class SavedNews extends StatefulWidget {
  final List<Data> savedList;
  SavedNews(this.savedList);
  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {

  Widget savedListViewer(dynamic data){
    return   ListView.builder(
      itemCount: widget.savedList.length,
      itemBuilder: (BuildContext context,int i){
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>WebtoViewer(data[i],widget.savedList)));
          },
          onDoubleTap: (){
            setState(() {
              widget.savedList.removeAt(i);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black12 ,
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0,bottom: 10.0,left: 15.0),
                            child: Container(
                              height: 20.0,
                              child: Text(data[i].source.name,style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black38),),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0,left: 15.0),
                              child: Container(
                                  alignment: Alignment.topCenter,
                                  child: Text(data[i].title,style: TextStyle(fontFamily:'OpenSans',fontWeight: FontWeight.w500, fontSize: 18.0),overflow: TextOverflow.ellipsis,maxLines: 3,)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 150.0,
                      width: 150.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: data[i].urltoimg == null ? Image( image: AssetImage("assets/img1.jpg"),fit: BoxFit.cover, ): Image( image: NetworkImage(data[i].urltoimg),fit: BoxFit.cover, ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget empty = Container(
    child: Center(
      child: Text("Empty",style: TextStyle(fontSize: 32.0),),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Bookmarks"),),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height - 90,
                    child: widget.savedList.length == 0 ? empty : savedListViewer(widget.savedList)
                )
            ],
          ),
        )
      ),
    );
  }
}
