// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'Barear.dart';
import 'GameList.dart';
import 'game_demo_display.dart';
class LandingPageView extends StatefulWidget {
  const LandingPageView({super.key});
  @override
  State<LandingPageView> createState() => _LandingPageViewState();
}

const List<Color> _kDefaultRainbowColors = const [
  Colors.yellow,
  Colors.green,
  Colors.blue,
];
class _LandingPageViewState extends State<LandingPageView> {
  //late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    myFuture= postRequest();

  }
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var extend = false;
  var mini = false;
  var rmicons = false;
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;
  var isDialOpen = ValueNotifier<bool>(false);
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = const Size(60.0, 60.0);
  var childrenButtonSize = const Size(60.0, 60.0);
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;
  late BerearToken  bt;//=new BarearToken();
  late GameList  gl;//=new BarearToken();
  late List<Data> gls;
  Future<void> GotoHome () async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LandingPageView()),
    );
  }
  Future<List<Data>> postRequest () async {
    var url ='https://api-staging.grplaying.com/api/v1/auth/gen-token';
    var body = jsonEncode({"agent": "demo" });

    //print("Body: " + body);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body
    );
    //print("${response.statusCode}");
    //print("${response.body}");
    //var responseJson = json.decode(response.body);

    final parsedJson = jsonDecode(response.body);
    //print("${parsedJson}");
    bt=BerearToken.fromJson(parsedJson);
    //print("Baearer ${bt.data}");
    var getGameLine=Uri.parse("https://api-staging.grplaying.com/api/v1/games");
    var gameListResponse = await http.get(getGameLine,
      headers: {"Authorization": "Bearer ${bt.data}"},
    );
   // print("${gameListResponse.statusCode}");
    //print("${gameListResponse.body}");
    //var responseJsonGameList = json.decode(gameListResponse.body);

    final responseJsonGameList = jsonDecode(gameListResponse.body);
    //print("${responseJsonGameList.l}");
    gl=GameList.fromJson(responseJsonGameList);
    gls=gl.data!;
    gls.sort((a, b) => a.order!.compareTo(b.order!));
    gls=gls.where((element) => element.active==true).toList();
    return gls;

  }
  late Future myFuture;
  @override
  Widget build(BuildContext context) {
    return Container(
        //your image here
        decoration: const BoxDecoration(
        image: DecorationImage(
        image: AssetImage("img/Landing_Page/Landing_Page_Background.png"),
    fit: BoxFit.cover,
    ),
    ),
    //your Scaffold goes here
    child:Scaffold(
      backgroundColor: Colors.transparent,
       /* appBar: AppBar(
          title: const Text('หน้าหลัก',style: TextStyle(color: Colors.white),),
          elevation: 0,
          flexibleSpace: const Image(
            image:AssetImage("img/ID_Page/ID_BG_02.png"),
            fit: BoxFit.cover,
          ),
         // backgroundColor: Colors.red,
        ),

        */
      body:FutureBuilder(
              future: myFuture,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ?
                Stack(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(30),
                    color: Colors.transparent,
                    child:  GridView.count(
                      // crossAxisCount is the number of columns

                      mainAxisSpacing: 12,
                      childAspectRatio: 1.6,
                      crossAxisCount: 2,
                      // This creates two columns with two items in each column
                      children: List.generate(gls.length, (index) {
                        return Center(

                            child:Card(

                              color: Colors.transparent,
                              elevation: 2,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child:InkWell(
                                    child:
                                    FadeInImage(
                                    placeholder: AssetImage('img/gameicon.png'),
                              image: NetworkImage('${gls[index].gameImageUrl}'),
                            ),






                                //    Image.network('${gls[index].gameImageUrl}'),
                                onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameWebView(gameCode: '${gls[index].code}')),
                        );
                        }, // Image tapped
                          splashColor: Colors.white10,
                                    )    ,//Image.asset('${gls![index].gameImageUrl}'),
                                  ),
                                  Text('${gls[index].name}',
                                      style: const TextStyle(color: Colors.white,fontSize: 16,),),
                                ],
                              ),
                            ),
                            /*
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => GameWebView(gameCode: '${gls![index].code}')),
                                );
                              }, // Image tapped
                              splashColor: Colors.white10, // Splash color over image
                              child: Ink.image(

                                fit: BoxFit.cover, // Fixes border issues
                                width: 100,
                                height: 100,
                                image: Image.network('${gls![index].gameImageUrl}').image,
                              ),
                            )

                             */
                        );
                      }),
                    )
                )
                ])
                    : Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {},
                          child:  Text('กำลังโหลด', style: const TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                    // Center(child: Text("กำลังโหลด",)),
                  ],
                );
              }),

      //floatingActionButton: favoriteButton(),
    )
    );
  }


}
