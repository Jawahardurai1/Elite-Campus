import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class CloudComputingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Computing Roadmap'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Cloud Computing Roadmap',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Timeline for Cloud Computing
            CloudComputingRoadmap(),

            SizedBox(height: 30),
            Text(
              'Top Companies Hiring for Cloud Roles',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // High-Paying Companies Section
            CompanyLogos(),
          ],
        ),
      ),
    );
  }
}

// Timeline with selectable steps
class CloudComputingRoadmap extends StatefulWidget {
  @override
  _CloudComputingRoadmapState createState() => _CloudComputingRoadmapState();
}

class _CloudComputingRoadmapState extends State<CloudComputingRoadmap> {
  int? selectedIndex;

  final steps = [
    {
      "title": "Learn Linux Basics",
      "url": "https://www.youtube.com/watch?v=IVquJh3DXUA",
    },
    {
      "title": "Understand Networking & Security",
      "url": "https://www.youtube.com/watch?v=qiQR5rTSshw",
    },
    {
      "title": "Learn Cloud Platforms (AWS, Azure, GCP)",
      "url": "https://www.youtube.com/watch?v=mxT233EdY5c",
    },
    {
      "title": "Get Hands-on with Docker & Kubernetes",
      "url": "https://www.youtube.com/watch?v=3c-iBn73dDE",
    },
    {
      "title": "Understand DevOps Practices",
      "url": "https://www.youtube.com/watch?v=_I94-tJlovg",
    },
    {
      "title": "Learn Infrastructure as Code (Terraform)",
      "url": "https://www.youtube.com/watch?v=7xngnjfIlK4",
    },
    {
      "title": "Get Certified (AWS/Azure/GCP)",
      "url": "https://www.youtube.com/watch?v=Ia-UEYYR44s",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        return TimelineStep(
          title: step['title']!,
          youtubeUrl: step['url']!,
          isFirst: index == 0,
          isLast: index == steps.length - 1,
          isSelected: selectedIndex == index,
          onTap: () async {
            setState(() {
              selectedIndex = index;
            });

            final url = Uri.parse(step['url']!);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
        );
      }),
    );
  }
}

// Reusable Timeline Step Widget with YouTube link and dynamic highlight
class TimelineStep extends StatelessWidget {
  final String title;
  final String youtubeUrl;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final VoidCallback onTap;

  const TimelineStep({
    required this.title,
    required this.youtubeUrl,
    this.isFirst = false,
    this.isLast = false,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 24,
        color: isSelected ? Colors.green : Colors.blue,
      ),
      beforeLineStyle: LineStyle(
        color: Colors.blue,
        thickness: 4,
      ),
      endChild: InkWell(
        onTap: onTap,
        child: Container(
          color: isSelected ? Colors.green.shade50 : Colors.transparent,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.play_circle_fill,
                  color: isSelected ? Colors.green : Colors.red, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.green[900] : Colors.black,
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

// Company Logos Section
class CompanyLogos extends StatelessWidget {
  final List<Map<String, dynamic>> companies = [
    {
      'logo': 'assets/aws1.png',
      'name': 'Amazon AWS',
      'certifications': [
        'AWS Cloud Practitioner',
        'AWS Solutions Architect',
      ],
    },
    {
      'logo': 'assets/google_cloud.png',
      'name': 'Google Cloud',
      'certifications': [
        'Associate Cloud Engineer',
        'Professional Cloud Architect',
      ],
    },
    {
      'logo': 'assets/microsoft_cloud.png',
      'name': 'Microsoft Azure',
      'certifications': [
        'Azure Fundamentals',
        'Azure Administrator Associate',
      ],
    },
    {
      'logo': 'assets/oracle_cloud.png',
      'name': 'Oracle Cloud',
      'certifications': [
        'Oracle Cloud Infrastructure Foundations',
        'OCI Architect Associate',
      ],
    },
  ];

  void _showCompanyDetails(BuildContext context, Map<String, dynamic> company) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${company['name']} Roles & Certifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Common Job Roles:', style: TextStyle(fontWeight: FontWeight.w600)),
            ...['Cloud Engineer', 'DevOps Specialist', 'Solutions Architect']
                .map((role) => ListTile(title: Text(role)))
                .toList(),
            Divider(),
            Text('Certifications:', style: TextStyle(fontWeight: FontWeight.w600)),
            ...company['certifications']
                .map<Widget>((cert) => ListTile(title: Text(cert)))
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return GestureDetector(
            onTap: () => _showCompanyDetails(context, company),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(company['logo'], width: 70),
            ),
          );
        },
      ),
    );
  }
}