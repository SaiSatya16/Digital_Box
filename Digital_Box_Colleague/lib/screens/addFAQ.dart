import 'package:flutter/material.dart';
import 'analytics.dart';
import 'home.dart';

class AddFAQScreen extends StatefulWidget {
  @override
  _AddFAQScreenState createState() => _AddFAQScreenState();
}

class _AddFAQScreenState extends State<AddFAQScreen> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'images/logo.png',
                height: 40.0,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'FAQ SECTION',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Baker',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),


      ),
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 0,
      //   color: Color(0xFF0A0E21),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           IconButton(
      //             icon: Icon(Icons.question_answer),
      //             onPressed: () {},
      //           ),
      //           Text(
      //             'Manage FAQs',
      //             style: TextStyle(fontSize: 10.0),
      //           ),
      //         ],
      //       ),
      //       Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           IconButton(
      //             icon: Icon(Icons.analytics),
      //             onPressed: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) {
      //                 return AnalyticsScreen();
      //               }));
      //             },
      //           ),
      //           Text(
      //             'Analytic Screen',
      //             style: TextStyle(fontSize: 10.0),
      //           ),
      //         ],
      //       ),
      //       Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           IconButton(
      //             icon: Icon(Icons.home),
      //             onPressed: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) {
      //                 return HomeScreen();
      //               }));
      //             },
      //           ),
      //           Text(
      //             'Home',
      //             style: TextStyle(fontSize: 10.0),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addFAQ();
              },
              child: Text('Add FAQ'),
            ),
          ],
        ),
      ),
    );
  }

  void _addFAQ() {
    String question = _questionController.text;
    String answer = _answerController.text;

    // Here you can perform the action to add the FAQ to your database or storage.
    // For demonstration, I'm just printing the entered question and answer.
    print('Question: $question');
    print('Answer: $answer');

    // Clearing the text fields after adding the FAQ
    _questionController.clear();
    _answerController.clear();

    // Show a snackbar or navigate to a different screen after adding the FAQ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('FAQ added successfully!'),
      ),
    );
  }
}
