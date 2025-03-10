import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
            title: const Text('Fleet Management System'),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("Find Workers & Jobs"),
              ),
              ListTile(
                title: Text("Repair Request Map")
              ),
              ListTile(
                title: Text("Service History"),
              )
            ],
          ),
        ),
        body: Center(
          child: Text('Insert Dashboard here'),
        ),
      );
  }
}

