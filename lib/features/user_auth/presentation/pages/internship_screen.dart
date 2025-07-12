import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InternshipScreen extends StatefulWidget {
  @override
  _InternshipScreenState createState() => _InternshipScreenState();
}

class _InternshipScreenState extends State<InternshipScreen> {
  List<Map<String, dynamic>> internships = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchInternships();
  }

  // Replace with your actual API endpoint
  Future<void> fetchInternships() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/intern/'));


      if (response.statusCode == 200) {
        // Parse JSON array of internship data
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          internships = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        // Handle error status
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      // Handle network or parsing errors
      setState(() {
        isLoading = false;
        isError = true;
      });
      print('Error fetching internships: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internship Opportunities'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text('Failed to load internships. Please try again.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: internships.length,
                  itemBuilder: (context, index) {
                    final item = internships[index];
                    return _buildInternshipCard(item);
                  },
                ),
    );
  }

Widget _buildInternshipCard(Map<String, dynamic> data) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    elevation: 5,
    margin: const EdgeInsets.only(bottom: 20),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField('Job Title', data['title'] ?? 'N/A'),
          _buildField('Company', data['company'] ?? 'N/A'),
          _buildField('Location', data['location'] ?? 'N/A'),
          _buildField('Posted Date', data['posted_date'] ?? 'N/A'),
          _buildField('Description', data['description'] ?? 'N/A'),
        ],
      ),
    ),
  );
}

  Widget _buildField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
