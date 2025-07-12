import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class FullStackRoadmapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Stack Developer Roadmap'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Step-by-Step Roadmap',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineTile(
            isFirst: true,
            title: 'Learn HTML, CSS, JavaScript',
            subtitle: 'Frontend Basics',
            icon: Icons.code,
            youtubeUrl: 'https://www.youtube.com/watch?v=UB1O30fR-EE',
          ),
          _buildTimelineTile(
            title: 'Master Frontend Frameworks',
            subtitle: 'React, Vue, or Angular',
            icon: Icons.web,
            youtubeUrl: 'https://www.youtube.com/watch?v=bMknfKXIFA8',
          ),
          _buildTimelineTile(
            title: 'Understand Backend',
            subtitle: 'Node.js, Django, or Spring Boot',
            icon: Icons.storage,
            youtubeUrl: 'https://www.youtube.com/watch?v=Oe421EPjeBE',
          ),
          _buildTimelineTile(
            title: 'Learn Databases',
            subtitle: 'SQL (PostgreSQL, MySQL) & NoSQL (MongoDB)',
            icon: Icons.dataset,
            youtubeUrl: 'https://www.youtube.com/watch?v=7S_tz1z_5bA',
          ),
          _buildTimelineTile(
            title: 'Build & Deploy Apps',
            subtitle: 'CI/CD, Docker, AWS, Firebase',
            icon: Icons.cloud,
            youtubeUrl: 'https://www.youtube.com/watch?v=9zUHg7xjIqQ',
          ),
          _buildTimelineTile(
            title: 'Apply for Jobs',
            subtitle: 'Top Companies Hiring',
            icon: Icons.work,
            youtubeUrl: 'https://www.youtube.com/watch?v=4KA80aUUX6g',
            isFinal: true,
          ),
          const SizedBox(height: 24),
          _buildCompanySection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTimelineTile({
    required String title,
    required String subtitle,
    required IconData icon,
    String? youtubeUrl,
    bool isFirst = false,
    bool isFinal = false,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isFinal,
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: Colors.blue,
        iconStyle: IconStyle(
          iconData: Icons.check,
          color: Colors.white,
        ),
      ),
      beforeLineStyle: LineStyle(color: Colors.blue, thickness: 3),
      endChild: InkWell(
        onTap: () async {
          if (youtubeUrl != null && await canLaunchUrl(Uri.parse(youtubeUrl))) {
            await launchUrl(Uri.parse(youtubeUrl), mode: LaunchMode.externalApplication);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.blue, size: 28),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.play_circle_fill, color: Colors.redAccent, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Hiring Companies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCompanyLogo('assets/google.png', 'Google'),
              _buildCompanyLogo('assets/meta.png', 'Meta'),
              _buildCompanyLogo('assets/amazon11.png', 'Amazon'),
              _buildCompanyLogo('assets/microsoft.png', 'Microsoft'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogo(String assetPath, String companyName) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(assetPath, width: 50, height: 50, fit: BoxFit.cover),
        ),
        const SizedBox(height: 6),
        Text(
          companyName,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
