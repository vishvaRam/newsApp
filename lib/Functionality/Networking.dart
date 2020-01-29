
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newsapp/Decode/data.dart';


class Networking {
  // to return the feature of output
  Future<List<Data>> output(String url) async{
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
        return local;
      }
    }catch(SocketException){
      print("Printed === "+SocketException.toString());
      return null;
    }
  }
}