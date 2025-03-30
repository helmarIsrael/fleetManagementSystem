import 'package:flutter/material.dart';
import 'package:fleetmanagementsystem/pages/workersAndJobsPage/workersAndJobsPage.dart';

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
              DrawerHeader(
                child: Text("Hello, User."),
              ),
              ListTile(
                title: Text("Find Workers & Jobs"),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WorkersAndJobsPage())),
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

