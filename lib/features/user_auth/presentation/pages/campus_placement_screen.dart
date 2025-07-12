import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CampusPlacementScreen extends StatefulWidget {
  @override
  _CampusPlacementScreenState createState() => _CampusPlacementScreenState();
}

class _CampusPlacementScreenState extends State<CampusPlacementScreen> {
  List<Map<String, dynamic>> placements = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchPlacements();
  }

  Future<void> fetchPlacements() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/placement/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          placements = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print('Error fetching campus placements: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Placement'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text('Failed to load placement data. Please try again.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: placements.length,
                  itemBuilder: (context, index) {
                    final item = placements[index];
                    return _buildPlacementCard(item);
                  },
                ),
    );
  }

  Widget _buildPlacementCard(Map<String, dynamic> data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('Title', data['title'] ?? 'N/A'),
            _buildField('Company', data['company'] ?? 'N/A'),
            _buildField('Rounds', data['rounds'] ?? 'N/A'),
            _buildField('Eligibility', data['Eligibility'] ?? 'N/A'), // Note the capital 'E'
            _buildField('Description', data['description'] ?? 'N/A'),
            _buildField('Posted Date', data['posted_date'] ?? 'N/A'),
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
