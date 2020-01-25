import 'package:flutter/material.dart';
import '../Style.dart';


// Card

Widget cardWidget = Padding(
  padding: const EdgeInsets.all(15.0),
  child: Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
            color: Colors.blue[100]
        )
    ),
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: Container(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0)),
                child: Image(
                    fit: BoxFit.cover,image: AssetImage('assets/img1.jpg')
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
                  child: Text("ABC News",style: publisherStyle,),
                ),
              ),
              Text("Your trusted source for breaking news, analysis, exclusive interviews, headlines, and ",style: headLineStyle,overflow: TextOverflow.ellipsis,maxLines: 3,)
            ],
          ),
        ),
      ],
    ),
  ),
);