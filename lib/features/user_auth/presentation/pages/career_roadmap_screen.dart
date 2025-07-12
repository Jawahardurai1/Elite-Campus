import 'package:flutter/material.dart';
import 'fullstack_roadmap_screen.dart';
import 'data_science_roadmap_screen.dart';
import 'cybersecurity_roadmap_screen.dart';
import 'cloud_roadmap_screen.dart';
import 'package:vitbhopal/features/user_auth/presentation/pages/internship_screen.dart';
import 'package:vitbhopal/features/user_auth/presentation/pages/campus_placement_screen.dart';

class CareerRoadmapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Career Portal'),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildMainCard(
              context,
              title: 'Campus Placement',
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CampusPlacementScreen()),
                );
              },
            ),
            SizedBox(height: 24),
            _buildMainCard(
              context,
              title: 'Internship',
              icon: Icons.work_outline,
             onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InternshipScreen()),
                );
              },
            ),
            SizedBox(height: 24),
            _buildMainCard(
              context,
              title: 'Career Roadmap',
              icon: Icons.map,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DomainListScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 5,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          width: double.infinity,
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class DomainListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> careerDomains = [
    {
      'title': 'Full Stack Developer',
      'icon': Icons.code,
      'screen': FullStackRoadmapScreen(),
    },
    {
      'title': 'Data Science',
      'icon': Icons.bar_chart,
      'screen': DataScienceRoadmapPage(),
    },
    {
      'title': 'Cybersecurity',
      'icon': Icons.security,
      'screen': CyberSecurityRoadmapPage(),
    },
    {
      'title': 'Cloud Computing',
      'icon': Icons.cloud,
      'screen': CloudComputingPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Career Roadmap'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: careerDomains.length,
        itemBuilder: (context, index) {
          final domain = careerDomains[index];
          return _buildDomainCard(
            context,
            title: domain['title'],
            icon: domain['icon'],
            screen: domain['screen'],
          );
        },
      ),
    );
  }

  Widget _buildDomainCard(BuildContext context,
      {required String title, required IconData icon, required Widget screen}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Material(
        elevation: 4,
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, size: 30, color: Colors.blue),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
