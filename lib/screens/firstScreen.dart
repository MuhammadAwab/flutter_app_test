import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabbedView extends StatefulWidget {
  @override
  _TabbedViewState createState() => _TabbedViewState();
}

class _TabbedViewState extends State<TabbedView> {
  int _selectedIndex = 0;
  void _itemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        initialIndex: 0,
        child: Scaffold(

            body: tabView(context),
            appBar: AppBar(
              title: Center(
                child: Text('Tabbed AppBar'),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.directions_car),child: Text('CAR',style: TextStyle(fontSize: 10),),),
                  Tab(icon: Icon(Icons.directions_bike),child: Text('BICYCLE',style: TextStyle(fontSize: 10)),),
                  Tab(icon: Icon(Icons.directions_bus),child: Text('BUS',style: TextStyle(fontSize: 10)),),
                  Tab(icon: Icon(Icons.directions_train),child: Text('TRAIN',style: TextStyle(fontSize: 10)),),
                  Tab(icon: Icon(Icons.directions_walk),child: Text('WALK',style: TextStyle(fontSize: 10)),)
          ],
        ),
      ),
          bottomNavigationBar: BottomNavigationBarTheme(
            data: BottomNavigationBarThemeData(type: BottomNavigationBarType.fixed),
            child: BottomNavigationBar(
              items: [
              BottomNavigationBarItem(
                  label: 'Bike'
                  ,icon: Icon(Icons.directions_bike)),
              BottomNavigationBarItem(label: 'Car'
                  ,icon: Icon(Icons.directions_car)),
              BottomNavigationBarItem(label: 'Bus'
                  ,icon: Icon(Icons.directions_bus)),
              BottomNavigationBarItem(label: 'Train'
                  ,icon: Icon(Icons.directions_train)),
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black45,
            currentIndex: _selectedIndex,
            onTap: _itemTapped,
            elevation: 12,
          )),
    ));
  }

  Widget tabView(BuildContext context){
    return TabBarView(
        children: [
          tabBarView(context,'CAR'),
          tabBarView(context,'BICYCLE'),
          tabBarView(context,'BUS'),
          tabBarView(context,'TRAIN'),
          tabBarView(context,'WALK'),
        ]);
  }

  Widget tabBarView(BuildContext context,String type){
    return Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon((type=='CAR')?Icons.directions_car:
              (type=='BICYCLE')?Icons.directions_bike:
              (type=='BUS')?Icons.directions_bus:
              (type=='TRAIN')?Icons.directions_train:
              (type=='WALK')?Icons.directions_walk:
              Icons.hourglass_empty
                ,size: 100,),
              Text(type,style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      );
  }

  Widget bikeView(BuildContext context){
    return Center(
      child: Column(
        children: [
          Icon(Icons.directions_bike),
          Text('BIKE')
        ],
      ),
    );
  }

  Widget busView(BuildContext context){
    return Center(
      child: Column(
        children: [
          Icon(Icons.directions_bus),
          Text('BUS')
        ],
      ),
    );
  }

  Widget trainView(BuildContext context){
    return Center(
      child: Column(
        children: [
          Icon(Icons.directions_train),
          Text('TRAIN')
        ],
      ),
    );
  }

  Widget walkView(BuildContext context){
    return Center(
      child: Column(
        children: [
          Icon(Icons.directions_walk),
          Text('WALK')
        ],
      ),
    );
  }

}
