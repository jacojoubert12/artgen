import 'package:flutter/material.dart';

class SubscriptionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg'),
                  fit: BoxFit.cover)),
        ),
        Container(
          decoration: BoxDecoration(color: Color.fromARGB(112, 181, 5, 134)),
          child: Row(
            children: <Widget>[
              SizedBox(),
              Expanded(
                flex: 1,
                child: Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                      color: Color.fromARGB(255, 31, 30, 30)),
                  child: Column(
                    children: <Widget>[
                      Text('Starter', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 400),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Subscribe'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                      color: Color.fromARGB(255, 31, 30, 30)),
                  child: Column(
                    children: <Widget>[
                      Text('Pro', style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 400,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Subscribe'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                      color: Color.fromARGB(255, 31, 30, 30)),
                  child: Column(
                    children: <Widget>[
                      Text('Max', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 400),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Subscribe'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
