import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class DataScienceRoadmapPage extends StatefulWidget {
  @override
  _DataScienceRoadmapPageState createState() => _DataScienceRoadmapPageState();
}

class _DataScienceRoadmapPageState extends State<DataScienceRoadmapPage> {
  Set<int> completedSteps = {};

  final List<String> roadmapSteps = [
    'Learn Programming (Python, R)',
    'Mathematics & Statistics',
    'Data Wrangling & Visualization',
    'Machine Learning',
    'Deep Learning',
    'Big Data & Cloud Computing',
    'Deploying ML Models',
  ];

  final List<String> youtubeLinks = [
    'https://www.youtube.com/watch?v=rfscVS0vtbw',
    'https://www.youtube.com/watch?v=xxpc-HPKN28',
    'https://www.youtube.com/watch?v=1Z6ofKNX0i8',
    'https://www.youtube.com/watch?v=GwIo3gDZCVQ',
    'https://www.youtube.com/watch?v=aircAruvnKk',
    'https://www.youtube.com/watch?v=_aWzGGNrcic',
    'https://www.youtube.com/watch?v=D1twn9kLmYg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Science Roadmap'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Data Science Roadmap',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(roadmapSteps.length, (index) {
                return RoadmapTile(
                  title: roadmapSteps[index],
                  isFirst: index == 0,
                  isLast: index == roadmapSteps.length - 1,
                  isCompleted: completedSteps.contains(index),
                  onTap: () async {
                    final url = youtubeLinks[index];
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      setState(() {
                        completedSteps.add(index);
                      });
                    }
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Top Companies Hiring Data Scientists',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const CompanyTile(
              logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu6nIyp4FniYdPM6-vDQqjWx2GDgqZB-SOMA&s',
              companyName: 'Google',
              salary: 'Avg. Salary: \$120,000/year',
            ),
            const CompanyTile(
              logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAE2DsdF6RJ3eiqVxPqVmsDix7QsIkFS_sVA&s',
              companyName: 'Amazon',
              salary: 'Avg. Salary: \$130,000/year',
            ),
            const CompanyTile(
              logoUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFRWT-hcJ-f4BG_ugvMwfcUCMKFsfCaC3kaw&s',
              companyName: 'IBM',
              salary: 'Avg. Salary: \$115,000/year',
            ),
          ],
        ),
      ),
    );
  }
}

class RoadmapTile extends StatelessWidget {
  final String title;
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;
  final VoidCallback onTap;

  const RoadmapTile({
    required this.title,
    this.isFirst = false,
    this.isLast = false,
    this.isCompleted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: isCompleted ? Colors.green : Colors.blue,
        iconStyle: IconStyle(
          iconData: isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: Colors.white,
        ),
      ),
      beforeLineStyle: const LineStyle(color: Colors.blue, thickness: 4),
      endChild: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green.shade50 : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isCompleted ? Colors.green[900] : Colors.black,
            ),
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

  const CompanyTile({
    required this.logoUrl,
    required this.companyName,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(logoUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(companyName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(salary),
      ),
    );
  }
}