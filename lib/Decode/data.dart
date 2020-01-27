
class Source{
  String name;
  Source({this.name});

  factory Source.fromJson(Map<String,dynamic> json){
    return Source(name: json['name']);
  }

  Map<String,dynamic> toMap() =>{
    "name": name
  };
}

class Data{
  Source source;
  String author;
  String title;
  String desc;
  String url;
  String urltoimg;
  Data({this.source,this.author,this.title,this.desc,this.url,this.urltoimg});

  factory Data.fromJson(Map<String,dynamic> json){
    return Data(
      source: Source.fromJson(json['source']),
      author: json['author'],
      title: json['title'],
      desc: json['description'],
      url: json['url'],
      urltoimg: json['urlToImage']
    );
  }

  Map<String,dynamic> toMap() => {
    "source": source.toMap().toString(),
    "url":url,
    "title":title,
    "urlToImage":urltoimg
  };

  Map<String,dynamic> toMapWithoutname() => {
    "url":url,
    "title":title,
    "urlToimage":urltoimg
  };
}