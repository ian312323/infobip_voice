import 'dart:async';

import 'package:flutter/material.dart';

import 'tabs/calls_tab.dart';
import 'tabs/conference_tab.dart';
import 'tabs/conversations_tab.dart';
import 'tabs/phone_call_tab.dart';
import 'tabs/sip_trunk_tab.dart';
import 'tabs/webrtc_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  void onSignOut() {
    // one to close the drawer, the second to close the page
    Navigator.pop(context);
    Navigator.pop(context);
    // todo - invalidate session
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle tabTextStyle = TextStyle(fontSize: 8);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebRTC Demo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.laptop),
              child: Text(
                "WebRTC",
                textAlign: TextAlign.center,
                style: tabTextStyle,
              ),
            ),
            Tab(
              icon: Icon(Icons.phone),
              child: Text(
                "Phone",
                textAlign: TextAlign.center,
                style: tabTextStyle,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            const ListTile(
              leading: Icon(Icons.sms_failed),
              title: Text('Feedback'),
            ),
            ListTile(
              leading: const Icon(Icons.power_settings_new),
              onTap: onSignOut,
              title: const Text('Sign Out'),
            ),
          ],
        ),
      ),
      body: Center(
        child: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            Center(child: WebRtcTab()),
            Center(child: PhoneCallTab()),
          ],
        ),
      ),
    );
  }
}
