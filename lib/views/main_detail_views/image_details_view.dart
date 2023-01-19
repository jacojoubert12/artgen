import 'package:flutter/material.dart';

class MyModal extends StatefulWidget {
  @override
  _MyModalState createState() => _MyModalState();
}

class _MyModalState extends State<MyModal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Stack(
        children: <Widget>[
          // Show previous page slightly greyed out
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  // Large Image
                  Image.network(
                    'https://via.placeholder.com/500x500',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  // Heart shaped 'like' button on top right corner of image
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {},
                      color: Colors.red,
                    ),
                  ),
                  // 3 Text Views
                  Text('Text View 1'),
                  Text('Text View 2'),
                  Text('Text View 3'),
                  // 2 Buttons next to each other
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Button 1'),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Button 2'),
                      ),
                    ],
                  ),
                  // 3 Buttons next to each other
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Button 3'),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Button 4'),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text('Button 5'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
