
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newsapp/Decode/data.dart';


class Networking {
  String url;
  Networking(this.url);

  Future<List<Data>> output() async{
    print(url);
    List local = List<Data>();
    try{
      http.Response res = await http.get(url);
      if(res.statusCode == 200){
        var decodedData = await jsonDecode(res.body)['articles'];
        if(decodedData==null){
          print("empty");
        }
        for(var i in decodedData){
          local.add(Data.fromJson(i));
        }
        print("got request");
      }
      else{
          throw("err");
      }
      return local;
    }catch(err){
      print(err);
      return null;
    }
  }
}