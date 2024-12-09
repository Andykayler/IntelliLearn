import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'adaptive_lesson_page.dart'; 

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String greeting = _getGreeting(); 
    int notificationCount = 3; 

    return Scaffold(
      body: Container(
   decoration: BoxDecoration(
     gradient: LinearGradient(
      colors: [Colors.white, Colors.grey.shade100],
                        begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
     ),
     ),
                        child: Column(
   children: [
                       _buildHeader(greeting, notificationCount),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    _sectionHeader("Your Progress"),
       _buildProgressCards(), 
                SizedBox(height: 20),
                    _sectionHeader("Quick Actions"),
                   _buildQuickActions(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Header with Greeting and Notifications
  Widget _buildHeader(String greeting, int notificationCount) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$greeting, John!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Tip: Consistency builds success!",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, size: 28),
                onPressed: () {
                  Get.snackbar("Notifications", "You have $notificationCount new notifications.");
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$notificationCount',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Section Header Widget
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Progress Cards with Navigation
  Widget _buildProgressCards() {
    List<Map<String, dynamic>> subjects = [
      {"name": "Mathematics", "progress": 60, "topic": "Calculus Basics"},
      {"name": "Science", "progress": 45, "topic": "Physics: Newton's Laws"},
      {"name": "Literature", "progress": 80, "topic": "Shakespeare's Sonnets"},
      {"name": "Computer Science", "progress": 30, "topic": "Introduction to Algorithms"},
    ];

    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to Adaptive Lesson Page
              Get.to(() => AdaptiveLessonPage(
                    subjectName: subjects[index]['name'],
                    topicTitle: subjects[index]['topic'],
                  ));
            },
            child: Container(
              width: 180,
              margin: EdgeInsets.only(left: 16, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subjects[index]['name'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text("${subjects[index]['progress']}% Completed",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: subjects[index]['progress'] / 100,
                        color: Colors.blue,
                        backgroundColor: Colors.grey.shade200,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Quick Actions Section
  Widget _buildQuickActions() {
    List<Map<String, dynamic>> actions = [
      {"icon": Icons.calendar_today, "label": "Study Plan", "onTap": () => Get.snackbar("Study Plan", "Coming Soon")},
      {"icon": Icons.group, "label": "Study Group", "onTap": () => Get.snackbar("Groups", "Coming Soon")},
      {"icon": Icons.star, "label": "Achievements", "onTap": () => Get.snackbar("Achievements", "Coming Soon")},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions
          .map(
            (action) => InkWell(
              onTap: action['onTap'],
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(action['icon'], color: Colors.blue, size: 30),
                  ),
                  SizedBox(height: 8),
                  Text(action['label'], style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analytics"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Groups"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Plans"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  // Dynamic Greeting
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }
}
