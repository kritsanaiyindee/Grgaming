// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:grgaming/main.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'landing_page.dart';


class GameWebView extends StatefulWidget {
  String? gameCode;
  GameWebView({required this.gameCode});

  @override
  State<GameWebView> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<GameWebView> {
 // static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
 // Map<String, dynamic> _deviceData = <String, dynamic>{};
  late final PlatformWebViewController  _controller;
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
  Future<void> initPlatformState() async {
   // var deviceData = <String, dynamic>{};
    //DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //print('androidInfo.serialNumber on ${androidInfo.id}');
/*
    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
        TargetPlatform.android =>
            _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
    TargetPlatform.iOS =>
    _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
    TargetPlatform.linux =>
    _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
    TargetPlatform.windows =>
    _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
    TargetPlatform.macOS =>
    _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
    TargetPlatform.fuchsia => <String, dynamic>{
    'Error:': 'Fuchsia platform isn\'t supported'
    },
    };
    }
    } on PlatformException {
    deviceData = <String, dynamic>{
    'Error:': 'Failed to get platform version.'
    };
    }

    if (!mounted) return;

    setState(() {
    _deviceData = deviceData;
    });

 */
  }
  @override
  void initState() {
    super.initState();


    initPlatformState();
    _controller = PlatformWebViewController(
      AndroidWebViewControllerCreationParams(),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x80000000))
      ..setPlatformNavigationDelegate(
        PlatformNavigationDelegate(
          const PlatformNavigationDelegateCreationParams(),
        )
          ..setOnProgress((int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          })
          ..setOnPageStarted((String url) {
            debugPrint('Page started loading: $url');
          })
          ..setOnPageFinished((String url) {
            debugPrint('Page finished loading: $url');
          })
          ..setOnWebResourceError((WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
  url: ${error.url}
          ''');
          })
          ..setOnNavigationRequest((NavigationRequest request) {
            if (request.url.contains('pub.dev')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          })
          ..setOnUrlChange((UrlChange change) {
            debugPrint('url change to ${change.url}');
          })
          ..setOnHttpAuthRequest((HttpAuthRequest request) {
            openDialog(request);
          }),
      )
      ..addJavaScriptChannel(JavaScriptChannelParams(
        name: 'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      ))
      ..setOnPlatformPermissionRequest(
            (PlatformWebViewPermissionRequest request) {
          debugPrint(
            'requesting permissions for ${request.types.map((WebViewPermissionResourceType type) => type.name)}',
          );
          request.grant();
        },
      )
      ..loadRequest(
        LoadRequestParams(
          uri: Uri.parse('https://api-staging.grplaying.com/api/v1/games/demo?gameCode=${this.widget.gameCode}')

        ),
      );
  }
  Future<void> GotoHome () async {
    Navigator.pop(context);
   /* Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: '',)),
    );

    */
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.green,
      backgroundColor: Colors.transparent,
      body:  PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(controller: _controller),
      ).build(context),
      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          // Respond to button press
          GotoHome();
        },
        icon: Icon(Icons.games),
        label: Text('เล่นเกมส์'),
      )
      /* SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        // / This is ignored if animatedIcon is non null
        // child: Text("open"),
        // activeChild: Text("close"),
        icon: Icons.settings,
        activeIcon: Icons.close,
        spacing: 3,
        mini: mini,
        openCloseDial: isDialOpen,
        childPadding: const EdgeInsets.all(5),
        spaceBetweenChildren: 4,

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
        elevation: 8.0,
        animationCurve: Curves.elasticInOut,
        isOpenOnStart: false,
        shape: customDialRoot
            ? const RoundedRectangleBorder()
            : const StadiumBorder(),
        // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: [
          SpeedDialChild(
            child: !rmicons ? const Icon(Icons.home_outlined) : null,
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
    );
  }

  Widget favoriteButton() {
    return
      Container(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
            child:

            FloatingActionButton(

      onPressed: () async {
        Navigator.pop(context);
        /*final String? url = await _controller.currentUrl();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorited $url')),
          );
        }

         */
      },
      child: const Icon(Icons.home_outlined),
      )

        )
    );
  }

  Future<void> openDialog(HttpAuthRequest httpRequest) async {
    final TextEditingController usernameTextController =
    TextEditingController();
    final TextEditingController passwordTextController =
    TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  autofocus: true,
                  controller: usernameTextController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: passwordTextController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Explicitly cancel the request on iOS as the OS does not emit new
            // requests when a previous request is pending.
            TextButton(
              onPressed: () {
                httpRequest.onCancel();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                httpRequest.onProceed(
                  WebViewCredential(
                    user: usernameTextController.text,
                    password: passwordTextController.text,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Authenticate'),
            ),
          ],
        );
      },
    );
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
  doPostRequest,
  loadLocalFile,
  loadFlutterAsset,
  loadHtmlString,
  transparentBackground,
  setCookie,
  logExample,
  basicAuthentication,
}



