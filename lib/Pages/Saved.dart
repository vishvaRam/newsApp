import 'package:flutter/material.dart';
import 'package:newsapp/Decode/data.dart';
import 'package:newsapp/Functionality/database.dart';
import 'WebView.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Singelton class instance
final dB = DatabaseHelper.instance;


class SavedNews extends StatefulWidget {
  List<Data> saved = List<Data>();
  SavedNews(this.saved);
  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {

  void showSnackBar(BuildContext context,String text){
    final snakBar = SnackBar(
      content: Text(text,style: TextStyle(fontSize: 18.0),),
      duration: Duration(seconds: 1),
      elevation: 9.0,
      backgroundColor: Theme.of(context).accentColor,
    );

    Scaffold.of(context).showSnackBar(snakBar);
  }

  Widget deleteBackground(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
      child: Container(
        margin: const EdgeInsets.only(top: 10.0,bottom: 10.0),
        decoration: BoxDecoration(
            color:Colors.redAccent
        ),
        child: Icon(Icons.delete,size: 45.0,),
      ),
    );
  }

  Widget savedListViewer(dynamic data){
    return   ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context,int i){
        return Dismissible(
          onDismissed: (direction) async{
            print(direction);
            print("to Delete");
            showSnackBar(context, "Deleted");
            await dB.delete(data[i].url);
          },
          key: Key(data[i].url),
          background: deleteBackground(context),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> WebtoViewer(data[i],widget.saved)));
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
                      child: Center(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 28,left: 15.0),
                            child: Container(
                                alignment: Alignment.topCenter,
                                child: Text(data[i].title,style: TextStyle(fontFamily:'OpenSans',fontWeight: FontWeight.w500, fontSize: 18.0),overflow: TextOverflow.ellipsis,maxLines: 4,)
                            ),
                          ),
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
                            child: data[i].urltoimg == null ?
                            Image( image: AssetImage("assets/img1.jpg"),fit: BoxFit.cover, )
                                :
                             CachedNetworkImage(
                               fit: BoxFit.cover,
                               imageUrl: data[i].urltoimg,
                               key: Key(data[i].urltoimg),
                               placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                               errorWidget: (context, url, error) => Icon(Icons.error_outline) ,
                             ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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
  void initState() {
    getDataFromDB();
    if(widget.saved != null){
      for(int i =0; i<widget.saved.length;i++){
        print(widget.saved[i].id);
      }
    }
    super.initState();
  }

  getDataFromDB() async{
    try{
      var result = await dB.queryAllRows();
      if(result != null){
        setState(() {
          widget.saved = result;
        });
      }
    }catch(NoSuchMethod){
      print('Emp');
    }
  }

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
                    child: widget.saved.length == 0 ? empty : savedListViewer(widget.saved.reversed.toList())
                )
            ],
          ),
        )
      ),
    );
  }
}
