import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:grgaming/Barear.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:grgaming/game_demo_display.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'GameList.dart';
import 'landing_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();

    initialization();
    myFuture=  postRequest();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }
/*
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

 */
  late BerearToken  bt;//=new BarearToken();
  late GameList  gl=new GameList();
  late List<Data> gls;
  late Future myFuture;
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
    //FlutterNativeSplash.remove();
    return gls;

  }
  @override
  Widget build(BuildContext context) {
    return

      Container(
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

           appBar: AppBar(
          title: const Text('เกมส์ทั้งหมด',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30,),),
          elevation: 0,
          flexibleSpace: const Image(
            image:AssetImage("img/ID_Page/ID_BG_02.png"),
            fit: BoxFit.cover,
          ),
         // backgroundColor: Colors.red,
        ),



            body:FutureBuilder(
                future: myFuture,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ?
                  Stack(

                      children: <Widget>[

                        Container(
                            margin: EdgeInsets.all(5),
                            color: Colors.transparent,
                            child:  GridView.count(
                              // crossAxisCount is the number of columns
                              padding: const EdgeInsets.symmetric(horizontal: 35),
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.9,
                              crossAxisCount: 2,
                              // This creates two columns with two items in each column
                              children: List.generate(gls.length, (index) {



                                /*
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
                                              width:100,
                                              //imageSemanticLabel: "xxxxxxxxxxx",
                                              placeholder: AssetImage('img/gameicon.png'),
                                              // image: AssetImage('img/gameicon.png'),
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
                                          style: const TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.bold),),
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

                                 */
                               return  GestureDetector(
                                   onTap: () {
                                   // ScaffoldMessenger.of(context).showSnackBar(
                                   //  SnackBar(content: Text('${gls[index].name}')));

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => GameWebView(gameCode: '${gls[index].code}')),
                                    );
                               },
                                child: Card(
                                  color: Colors.transparent,
                                  child: Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(0)),
                                    margin: EdgeInsets.all(1),
                                    padding: EdgeInsets.all(1),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(

                                              child: Image.network(
                                                '${gls[index].gameImageUrl}',
                                                fit: BoxFit.fill,


                                              ),
                                            ),
                                            Text(
                                              '${gls[index].name!.split(" ").last}',
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                              ),
                                            ),
                                            /*
                                            Row(
                                              children: [
                                                Text(
                                                  'Subtitle',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            )

                                             */
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                               );
                              }

                              ),

                            )
                        )
                      ])
                      :    Stack(
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
                            child:  Text('กำลังโหลด', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
                                color: Colors.white),),
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
    /*
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
                              //log('onPressed');
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


    */


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