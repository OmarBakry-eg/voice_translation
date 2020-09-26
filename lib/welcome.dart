import 'package:flutter/material.dart';
import 'consts.dart';
import 'speech.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String name, to = 'ar';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Welcome to voice translation'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.input),
                      hintText: 'Type your name',
                      labelText: 'Name'),
                  onChanged: (String val) {
                    name = val;
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'From English To',
                style: TextStyle(
                    fontSize: 24, color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButton(
                value: to,
                onChanged: (val) {
                  setState(() {
                    to = val;
                    print(to);
                  });
                },
                items: langs
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(
                height: 60,
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpeechScreen(
                          name: name,
                          to: to,
                        ),
                      ),
                    );
                    print(to);
                  },
                  child: Text('Work now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
