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
                title: Text("Job Orders"),
              ),
              ListTile(
                title: Text("Maps")
              ),
              ListTile(
                title: Text("Order History"),
              )
            ],
          ),
        ),
        body: Center(
          child: Text('Hello World!'),
        ),
      );
  }
}

