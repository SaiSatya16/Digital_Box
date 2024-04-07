import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'analytics.dart';
import 'addFAQ.dart';
import 'DocumentRequestScreen.dart';
import 'Chat.dart';
import 'showDocuments.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colleague Complaints App',
      theme: ThemeData(
        primaryColor: const Color(0xFF2196F3),
        hintColor: const Color(0xFF64B5F6),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: const Color(0xFF2196F3),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Baker',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF64B5F6),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              'Pending Tickets',
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
      body: TicketList(),
      bottomNavigationBar: SingleChildScrollView(
        child: BottomAppBar(
          elevation: 0,
          color: const Color(0xFF2196F3),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomNavItem(Icons.question_answer, 'Manage FAQs',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddFAQScreen()),
                      );
                    }),
                    _buildBottomNavItem(Icons.analytics, 'Analytics', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnalyticsScreen()),
                      );
                    }),
                    _buildBottomNavItem(Icons.request_page, 'Request a Document',
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocumentRequestScreen()),
                      );
                    }),
                    _buildBottomNavItem(Icons.request_page, 'Documents Repository',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DocumentScreen()),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
      IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          color: Colors.white,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10.0, color: Colors.white),
        ),
      ],
    );
  }
}

class TicketList extends StatefulWidget {
  @override
  _TicketListState createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  List<Complaint> complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/complaints'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          complaints = data.map((e) => Complaint.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load complaints');
      }
    } catch (error) {
      print('Error fetching complaints: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              return TicketCard(complaint: complaints[index]);
            },
          );
  }
}

class TicketCard extends StatefulWidget {
  final Complaint complaint;

  TicketCard({required this.complaint});

  @override
  _TicketCardState createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF64B5F6),
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SizedBox(
        height: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                '${widget.complaint.complaintId.substring(0, 10)} - ${widget.complaint.title}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded
                      ? widget.complaint.description
                      : getExpandableDescription(
                          widget.complaint.description, 30),
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                color: Colors.white,
                onPressed: () async {
                  String userId = await fetchCurrentUserUid();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        complaintId: widget.complaint.complaintId,
                        userId: userId,
                        ticketId: widget.complaint.ticketId,
                        ticketStatus: widget.complaint.ticketStatus,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getExpandableDescription(String description, int limit) {
    if (description.length <= limit) return description;

    if (limit <= 0) return '';

    return description.substring(0, limit) + '... (See more)';
  }
}

class Complaint {
  final String complaintId;
  final String title;
  final String description;
  final String category;
  final String userId;
  final DateTime createdAt;
  final String ticketId;
  final String ticketStatus;

  Complaint({
    required this.complaintId,
    required this.title,
    required this.description,
    required this.category,
    required this.userId,
    required this.createdAt,
    required this.ticketId,
    required this.ticketStatus,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      complaintId: json['complaint_id'],
      title: json['complaint_data']['title'],
      description: json['complaint_data']['description'],
      category: json['complaint_data']['category'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      ticketId: json['ticketID'],
      ticketStatus: json['ticket_status'],
    );
  }
}

Future<List<AuthUserAttribute>> fetchCurrentUserAttributes() async {
  try {
    final result = await Amplify.Auth.fetchUserAttributes();
    return result;
  } on AuthException catch (e) {
    print('Error fetching user attributes: ${e.message}');
    return [];
  }
}

Future<String> fetchCurrentUserUid() async {
  try {
    final attributes = await fetchCurrentUserAttributes();
    for (var attribute in attributes) {
      print(
          'User attribute: ${attribute.userAttributeKey} - ${attribute.value}');
      if ('${attribute.userAttributeKey}' == 'sub') {
        return '${attribute.value}';
      }
    }
    return '';
  } catch (e) {
    print('Error fetching user ID: $e');
    return '';
  }
}
