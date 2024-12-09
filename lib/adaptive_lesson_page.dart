import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class AdaptiveLessonPage extends StatefulWidget {
  final String subjectName;
  final String topicTitle;

  AdaptiveLessonPage({required this.subjectName, required this.topicTitle});

  @override
  _AdaptiveLessonPageState createState() => _AdaptiveLessonPageState();
}

class _AdaptiveLessonPageState extends State<AdaptiveLessonPage> {
  bool isDarkMode = false;
  int streakCount = 5;

 
  final List<Map<String, String>> messages = [];
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.blue.shade600,
        title: Text(
          "IntelliLearn",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Get.snackbar("Search", "Search functionality coming soon!");
            },
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble_outline),
            onPressed: () {
              _openChatInterface();
            },
          ),
        ],
      ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 768) _buildSideNavigationBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 20),
                  _buildMasteryTracker(),
                  SizedBox(height: 20),
                  _buildVideoLessons(),
                  SizedBox(height: 20),
                  _buildGamificationFeatures(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.snackbar("Quiz", "Start your quiz!");
        },
        label: Text("Start Quiz"),
        icon: Icon(Icons.play_arrow),
        backgroundColor: isDarkMode ? Colors.orange : Colors.blue.shade600,
      ),
    );
  }

  void _openChatInterface() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              _buildChatHeader(),
              Expanded(child: _buildChatMessages()),
              _buildChatInput(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.blue.shade600,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Ask IntelliLearn",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        bool isUser = message['sender'] == 'user';
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser
                  ? (isDarkMode ? Colors.orange : Colors.blue.shade600)
                  : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message['text']!,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatInput() {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: isDarkMode ? Colors.orange : Colors.blue),
            onPressed: _pickFile,
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                filled: true,
                fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: isDarkMode ? Colors.orange : Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({'sender': 'user', 'text': messageController.text.trim()});
        messages.add({'sender': 'bot', 'text': "This is an AI-generated response."});
      });
      messageController.clear();
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      final fileName = result.files.first.name;
      setState(() {
        messages.add({'sender': 'user', 'text': "File attached: $fileName"});
        messages.add({'sender': 'bot', 'text': "I have received your file and will process it."});
      });
    }
  }

  
  Widget _buildSideDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.blue.shade600,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  "Welcome, Student!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "AI-Powered Learning Assistant",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, "Dashboard", () {}),
          _buildDrawerItem(Icons.book, "Subjects", () {}),
          _buildDrawerItem(Icons.emoji_events, "Achievements", () {}),
          _buildDrawerItem(Icons.settings, "Settings", () {}),
        ],
      ),
    );
  }

  Widget _buildSideNavigationBar() {
    return Container(
      width: 200,
      color: isDarkMode ? Colors.grey.shade900 : Colors.blue.shade50,
      child: Column(
        children: [
          _buildDrawerItem(Icons.home, "Dashboard", () {}),
          _buildDrawerItem(Icons.book, "Subjects", () {}),
          _buildDrawerItem(Icons.emoji_events, "Achievements", () {}),
          _buildDrawerItem(Icons.settings, "Settings", () {}),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.orange : Colors.blue),
      title: Text(
        title,
        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
      ),
      onTap: onTap,
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Hi, Welcome Back!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        Row(
          children: [
            Icon(Icons.local_fire_department, color: Colors.orange),
            SizedBox(width: 5),
            Text(
              "$streakCount-day streak",
              style: TextStyle(color: isDarkMode ? Colors.orange : Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMasteryTracker() {
    return Card(
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mastery Tracker",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            _buildProgressWithRecommendation("Understanding Basics", 0.8, "Revise core definitions."),
            _buildProgressWithRecommendation("Applying Concepts", 0.6, "Practice with real-world examples."),
            _buildProgressWithRecommendation("Problem-Solving", 0.5, "Focus on tricky problems."),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressWithRecommendation(String skill, double progress, String recommendation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          skill,
          style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          color: isDarkMode ? Colors.orange : Colors.blue,
          minHeight: 8,
        ),
        SizedBox(height: 5),
        Text(
          "Recommendation: $recommendation",
          style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.white54 : Colors.black54),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildVideoLessons() {
    return Card(
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Video Lessons",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Enhance your understanding with interactive video lessons.",
              style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDarkMode ? Colors.black12 : Colors.blue.shade50,
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.play_circle_outline,
                    size: 64,
                    color: isDarkMode ? Colors.orange : Colors.blue.shade600,
                  ),
                  onPressed: () {
                    Get.snackbar("Video Playback", "Starting video lesson...");
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Introduction to ${widget.topicTitle}",
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                Text(
                  "Duration: 5:30",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamificationFeatures() {
    return Card(
      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Achievements",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Complete lessons and quizzes to earn badges!",
              style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.orange, size: 30),
                SizedBox(width: 10),
                Text(
                  "Master Learner Badge",
                  style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.orange : Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
