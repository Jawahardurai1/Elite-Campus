import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class CyberSecurityRoadmapPage extends StatefulWidget {
  @override
  _CyberSecurityRoadmapPageState createState() => _CyberSecurityRoadmapPageState();
}

class _CyberSecurityRoadmapPageState extends State<CyberSecurityRoadmapPage> {
  int? selectedStepIndex;

  final List<Map<String, String>> roadmapSteps = [
    {
      'title': 'Learn Networking & Operating Systems',
      'url': 'https://www.youtube.com/watch?v=qiQR5rTSshw',
    },
    {
      'title': 'Understand Security Fundamentals',
      'url': 'https://www.youtube.com/watch?v=tZ8v3oHxuQY',
    },
    {
      'title': 'Learn Cryptography & Encryption',
      'url': 'https://www.youtube.com/watch?v=aHhDmcC6wqk',
    },
    {
      'title': 'Ethical Hacking & Penetration Testing',
      'url': 'https://www.youtube.com/watch?v=U4mz0xwPIx4',
    },
    {
      'title': 'Incident Response & Security Tools',
      'url': 'https://www.youtube.com/watch?v=n4v7Q5Mmtpo',
    },
    {
      'title': 'Cloud Security & Compliance',
      'url': 'https://www.youtube.com/watch?v=Y_XT3d_1A9o',
    },
    {
      'title': 'Advanced Cyber Threat Intelligence',
      'url': 'https://www.youtube.com/watch?v=EvMqubBRqgU',
    },
  ];

  void _handleTap(int index, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      setState(() {
        selectedStepIndex = index;
      });
    }
  }

  void _showCompanyDetails(BuildContext context, String companyName, String logoUrl, List<String> roles, List<String> certifications) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Image.network(logoUrl, width: 40, height: 40),
            SizedBox(width: 10),
            Text(companyName),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Common Roles:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...roles.map((role) => ListTile(title: Text(role))),
              SizedBox(height: 10),
              Text('Certifications:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...certifications.map((cert) => ListTile(title: Text(cert))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cyber Security Roadmap'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Cyber Security Roadmap',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Roadmap Tiles
            ...List.generate(roadmapSteps.length, (index) {
              final isFirst = index == 0;
              final isLast = index == roadmapSteps.length - 1;
              final step = roadmapSteps[index];
              return RoadmapTile(
                index: index,
                isFirst: isFirst,
                isLast: isLast,
                title: step['title']!,
                youtubeUrl: step['url']!,
                isSelected: selectedStepIndex == index,
                onTap: _handleTap,
              );
            }),

            SizedBox(height: 20),
            Text(
              'Top Companies Hiring Cyber Security Experts',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            CompanyTile(
              logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu6nIyp4FniYdPM6-vDQqjWx2GDgqZB-SOMA&s',
              companyName: 'Google',
              salary: 'Avg. Salary: \$130,000/year',
              onTap: () => _showCompanyDetails(
                context,
                'Google',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu6nIyp4FniYdPM6-vDQqjWx2GDgqZB-SOMA&s',
                ['Security Engineer', 'Threat Analyst', 'Red Team Specialist'],
                ['Google Cybersecurity Certificate', 'CompTIA Security+'],
              ),
            ),
            CompanyTile(
              logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAE2DsdF6RJ3eiqVxPqVmsDix7QsIkFS_sVA&s',
              companyName: 'Amazon Security Team',
              salary: 'Avg. Salary: \$140,000/year',
              onTap: () => _showCompanyDetails(
                context,
                'Amazon Security Team',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAE2DsdF6RJ3eiqVxPqVmsDix7QsIkFS_sVA&s',
                ['Cloud Security Engineer', 'Incident Response Specialist', 'Security Operations Analyst'],
                ['AWS Security Specialty', 'Certified Ethical Hacker (CEH)'],
              ),
            ),
            CompanyTile(
              logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqHxfp5_IxQLcw1D8CVTi6ouBWcTy2m6sxHw&s',
              companyName: 'Cisco',
              salary: 'Avg. Salary: \$120,000/year',
              onTap: () => _showCompanyDetails(
                context,
                'Cisco',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqHxfp5_IxQLcw1D8CVTi6ouBWcTy2m6sxHw&s',
                ['Security Analyst', 'Network Security Engineer', 'SOC Analyst'],
                ['Cisco CyberOps Associate', 'Cisco CCNP Security'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoadmapTile extends StatelessWidget {
  final String title;
  final String youtubeUrl;
  final bool isFirst;
  final bool isLast;
  final int index;
  final bool isSelected;
  final Function(int, String) onTap;

  const RoadmapTile({
    required this.index,
    required this.title,
    required this.youtubeUrl,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: isSelected ? Colors.green : Colors.blue,
        iconStyle: IconStyle(iconData: Icons.security, color: Colors.white),
      ),
      beforeLineStyle: LineStyle(color: Colors.blue, thickness: 4),
      endChild: InkWell(
        onTap: () => onTap(index, youtubeUrl),
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[400] : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.play_circle_fill, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyTile extends StatelessWidget {
  final String logoUrl;
  final String companyName;
  final String salary;
  final VoidCallback onTap;

  const CompanyTile({
    required this.logoUrl,
    required this.companyName,
    required this.salary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        onTap: onTap,
        leading: Image.network(logoUrl, width: 50, height: 50),
        title: Text(companyName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(salary),
      ),
    );
  }
}