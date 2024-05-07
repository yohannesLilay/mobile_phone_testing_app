import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String redStatus = 'Not Tested';
  String greenStatus = 'Not Tested';
  String blueStatus = 'Not Tested';
  String touchStatus = 'Not Tested';
  String speakerStatus = 'Not Tested';
  String sensorStatus = 'Not Tested';
  String subKeyStatus = 'Not Tested';
  String vibrationStatus = 'Not Tested';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Phone Tests'),
      ),
      body: ListView(
        children: [
          _buildRow(context, [
            _buildCard(context, 'Red', redStatus, () async {
              final result = await Navigator.pushNamed(context, '/red_screen');
              setState(() {
                redStatus = _getResultStatus(result.toString());
              });
            }),
            _buildCard(context, 'Green', greenStatus, () async {
              final result =
                  await Navigator.pushNamed(context, '/green_screen');
              setState(() {
                greenStatus = _getResultStatus(result.toString());
              });
            }),
            _buildCard(context, 'Blue', blueStatus, () async {
              final result = await Navigator.pushNamed(context, '/blue_screen');
              setState(() {
                blueStatus = _getResultStatus(result.toString());
              });
            }),
          ]),
          _buildRow(context, [
            _buildCard(context, 'Touch', touchStatus, () async {
              final result =
                  await Navigator.pushNamed(context, '/touch_test_screen');
              setState(() {
                touchStatus = _getResultStatus(result.toString());
              });
            }),
            _buildCard(context, 'Speaker', speakerStatus, () async {
              final result =
                  await Navigator.pushNamed(context, '/speaker_screen');
              setState(() {
                speakerStatus = _getResultStatus(result.toString());
              });
            }),
            _buildCard(context, 'Sensor', sensorStatus, () async {
              final result =
                  await Navigator.pushNamed(context, '/sensor_screen');
              setState(() {
                sensorStatus = _getResultStatus(result.toString());
              });
            }),
          ]),
          _buildRow(context, [
            _buildCard(context, 'Sub Key', subKeyStatus, () async {
              final result =
                  await Navigator.pushNamed(context, '/sub_key_screen');
              setState(() {
                subKeyStatus = _getResultStatus(result.toString());
              });
            }),
            _buildCard(context, 'Vibration', vibrationStatus, () async {
              final result =
                  await Navigator.pushNamed(context, '/vibration_screen');
              setState(() {
                vibrationStatus = _getResultStatus(result.toString());
              });
            }),
            _buildCard(context, 'Detect Sim', '', () {
              Navigator.pushNamed(context, '/detect_sim_screen');
            }),
          ]),
          _buildRow(context, [
            _buildCard(context, 'Device Information', '', () {
              Navigator.pushNamed(context, '/device_information_screen');
            }),
            // Add more cards if needed
          ]),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 0.0,
        runSpacing: 0.0,
        children: children,
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String text, String status, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 32) /
        3; // Subtracting padding and dividing by number of cards per row

    return SizedBox(
      width: cardWidth,
      height: 150,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text.toUpperCase(),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 8),
                // Adding space between text and status
                Text(
                  status,
                  style:
                      TextStyle(fontSize: 14.0, color: _getStatusColor(status)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Passed':
      case '100% Passed':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      case 'Not Tested':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  String _getResultStatus(String? result) {
    if (result == null || result == 'null' || result.isEmpty) {
      return 'Failed';
    } else {
      return result;
    }
  }
}
