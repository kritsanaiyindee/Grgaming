// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

import 'Barear.dart';
import 'GameList.dart';
import 'landing_page.dart';
// #enddocregion platform_imports

void main() => runApp(const MaterialApp(home: GrGaming()));

const List<Color> _kDefaultRainbowColors = const [

  Colors.yellow,
  Colors.green,
  Colors.blue,

];
class GrGaming extends StatefulWidget {
  const GrGaming({super.key});

  @override
  State<GrGaming> createState() => _GrGamingState();
}

class _GrGamingState extends State<GrGaming> {
  late BerearToken  bt;//=new BarearToken();
  late GameList  gl;//=new BarearToken();
  late List<Data> gls;

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
  var buttonSize = const Size(64.0, 64.0);
  var childrenButtonSize = const Size(64.0, 64.0);
  var selectedfABLocation = FloatingActionButtonLocation.endDocked;
  var items = [
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
  ];
  Future<void> GotoHome () async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LandingPageView()),
    );
  }

  Future<List<Data>> postRequest () async {
    var url ='https://api-staging.grplaying.com/api/v1/auth/gen-token';
    var body = jsonEncode({"agent": "demo" });

    print("Body: " + body);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print("${response.statusCode}");
    print("${response.body}");
    //var responseJson = json.decode(response.body);

    final parsedJson = jsonDecode(response.body);
    print("${parsedJson}");
    bt=BerearToken.fromJson(parsedJson);
    print("Baearer ${bt.data}");
    var getGameLine=Uri.parse("https://api-staging.grplaying.com/api/v1/games");
    var gameListResponse = await http.get(getGameLine,
      headers: {"Authorization": "Bearer ${bt.data}"},
    );
    print("${gameListResponse.statusCode}");
    print("${gameListResponse.body}");
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
  void initState() {
    super.initState();
    myFuture= postRequest();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //your image here
      decoration: BoxDecoration(
        image: DecorationImage(
          //image: AssetImage("img/Landing_Page/Landing_Page_Background.png/Landing Page_0.png"),
          image: AssetImage("img/Landing_Page/Landing_Page_Background.png"),
          fit: BoxFit.cover,
        ),
      ),
      //your Scaffold goes here
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: FutureBuilder(
              future: myFuture,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ?Container(
                    padding: EdgeInsets.all(
                        16.0),
                    child:
                    Column(children: [


                      Row(children: [
                        //5th row
                        Expanded(
                            child: ElevatedButton (
                              //padding: EdgeInsets.all(24.0),

                              style: OutlinedButton.styleFrom(
                                  side: BorderSide.none,
                                  backgroundColor: Colors.transparent
                              ),
                              child: Image.asset(
                                'img/Landing_Page/GR_Gaming_Text.png',
                                fit: BoxFit.cover,
                                // width: 80,
                                //  height: 80,
                              ),//   AssetImage("assets/background_button.png").,

                              onPressed: () {
                                //  Navigator.of(context).push(_goToFirstPage());
                                // _showToast();
                                log('onPressed');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LandingPageView()),
                                );
                              },
                            ))
                      ]),

                      // Center(child: Text("GR Gaming")),
                    ])
                )

                    :Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                          width: 150,
                          height: 150,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballRotateChase,
                            colors: _kDefaultRainbowColors,
                            strokeWidth: 0.4,
                          )
                      ),
                    ),
                    //Center(child: Text("Test",)),
                  ],
                );

              }),
          floatingActionButton:FloatingActionButton.extended(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            onPressed: () {
              // Respond to button press
              GotoHome();
            },
            icon: Icon(Icons.games),
            label: Text('เล่นเกมส์',style: TextStyle(fontSize: 17),),
          )
        /*
        SpeedDial(
          // animatedIcon: AnimatedIcons.menu_close,
          // animatedIconTheme: IconThemeData(size: 22.0),
          // / This is ignored if animatedIcon is non null
          // child: Text("open"),
          // activeChild: Text("close"),
          icon: Icons.menu,
          activeIcon: Icons.close,
          spacing: 1,
          mini: mini,
          openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 2,
          dialRoot: customDialRoot
              ? (ctx, open, toggleChildren) {
            return ElevatedButton(
              onPressed: toggleChildren,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 22, vertical: 18),
              ),
              child: const Text(
                "เมนู",
                style: TextStyle(fontSize: 17),
              ),
            );
          }
              : null,
          buttonSize:
          buttonSize, // it's the SpeedDial size which defaults to 56 itself
          // iconTheme: IconThemeData(size: 22),

          label: extend
              ? const Text("เมนู")
              : Text("เมนู"), // The label of the main button.
          /// The active label of the main button, Defaults to label if not specified.
          activeLabel: extend ? const Text("ปิด") : Text("ปิด"),

          /// Transition Builder between label and activeLabel, defaults to FadeTransition.
          // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
          /// The below button size defaults to 56 itself, its the SpeedDial childrens size
          childrenButtonSize: childrenButtonSize,
          visible: visible,
          direction: speedDialDirection,
          switchLabelPosition: switchLabelPosition,

          /// If true user is forced to close dial manually
          closeManually: closeManually,

          /// If false, backgroundOverlay will not be rendered.
          renderOverlay: false,
          // overlayColor: Colors.black,
          // overlayOpacity: 0.5,
          onOpen: () => debugPrint('OPENING DIAL'),
          onClose: () => debugPrint('DIAL CLOSED'),
          useRotationAnimation: useRAnimation,
          tooltip: 'Open Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          // foregroundColor: Colors.black,
          // backgroundColor: Colors.white,
          // activeForegroundColor: Colors.red,
          // activeBackgroundColor: Colors.blue,
          elevation: 2.0,
          animationCurve: Curves.elasticInOut,
          isOpenOnStart: false,
          shape: customDialRoot
              ? const RoundedRectangleBorder()
              : const StadiumBorder(),
          // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: [
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.home) : null,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'หน้าเกมส์',
              onTap: () => GotoHome(),

              onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
            ),
            SpeedDialChild(
              child: !rmicons ? const Icon(Icons.settings) : null,
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: 'ตั้งค่า',
              onTap: () => debugPrint('SECOND CHILD'),
            ),

          ],
        ),

         */
      ),
    );
    /* return Scaffold(
      backgroundColor: Colors.green,
      /*appBar: AppBar(
        title: const Text('Flutter WebView example'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(webViewController: _controller),
          SampleMenu(webViewController: _controller),
        ],
      ),*/

      body: Material(
        child: FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          return snapshot.hasData
              ?Container(
              color: Colors.transparent,
              child:  GridView.count(
              // crossAxisCount is the number of columns
              childAspectRatio: 4/3,
              crossAxisCount: 2,
              // This creates two columns with two items in each column
              children: List.generate(gls!.length, (index) {
                return Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GameWebView()),
                      );
                    }, // Image tapped
                    splashColor: Colors.white10, // Splash color over image
                    child: Ink.image(
                      fit: BoxFit.cover, // Fixes border issues
                      width: 150,
                      height: 150,
                      image: Image.network('${gls![index].gameImageUrl}').image,
                    ),
                  )
                );
              }),
            )
            )
              : Container(
              child: Center(child: CircularProgressIndicator()));
        })
    ),






    // WebViewWidget(controller: _controller),
     // floatingActionButton: favoriteButton(),
    );

    */
  }




}


