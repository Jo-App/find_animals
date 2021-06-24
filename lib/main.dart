import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(LayoutBuilder(
    builder: (context, constraints){
      return GetMaterialApp(
        home: Home(),
        title: "경기도 유기동물",
        
      );
    }
  ));
}

class Home extends StatefulWidget {
  const Home({ Key key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _children = [
    Center(child:Text("AAA")),
    Center(child:Text("BBB")),
  ];
  int currentIndex = 0;
  ListQueue _navigationQueue = ListQueue();

  
  void changeMenu(int index) {
    if (index != currentIndex) {
      _navigationQueue.removeWhere((element) => element == index);
      _navigationQueue.addLast(index);
      setState(() {
        currentIndex = index;
      });
      print(_navigationQueue);
    }
  }

  //뒤로가기 누를시 전의 메뉴로 이동하고 큐를 지운다 큐가 비어졌다면 종료 알림응 보여준다
  Future<bool> _onWillPop() async {
    //Navigator.of(context).pop();
    if (_navigationQueue.isEmpty) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('확인'),
          content: Text('앱을 종료 하시겠습니까?'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('네')),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('아니오')),
          ],
        ),
      );
      //return true;
    }
     setState(() {
      _navigationQueue.removeLast();
      int position = _navigationQueue.isEmpty ? 0 : _navigationQueue.last;
      currentIndex = position;
    });
    return false;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _children,
      ),
      bottomNavigationBar: Wrap(children: [
        WillPopScope(
          onWillPop: _onWillPop,
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            currentIndex: currentIndex,
            onTap: changeMenu,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('홈')),
              BottomNavigationBarItem(icon: Icon(Icons.android), title: Text('안드로이드'))
            ],
          ),
        ),
      ]),
    );
  }
}