import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_number/mobile_number.dart';

class DetectSimScreen extends StatefulWidget {
  const DetectSimScreen({super.key});

  @override
  State<DetectSimScreen> createState() => _DetectSimScreenState();
}

class _DetectSimScreenState extends State<DetectSimScreen> {
  List<String> _simNumbers = [];
  bool _hasPhonePermission = false;

  @override
  void initState() {
    super.initState();
    _checkPhonePermission();
  }

  Future<void> _checkPhonePermission() async {
    try {
      final hasPermission = await MobileNumber.hasPhonePermission;
      setState(() {
        _hasPhonePermission = hasPermission;
      });
      if (!hasPermission) {
        await _requestPhonePermission();
      } else {
        _detectSimNumbers();
      }
    } catch (e) {
      print('Error checking phone permission: $e');
    }
  }

  Future<void> _requestPhonePermission() async {
    try {
      await Permission.phone.request();
      setState(() {
        _hasPhonePermission = true;
      });
      _detectSimNumbers();
    } catch (e) {
      print('Error requesting phone permission: $e');
    }
  }

  Future<void> _detectSimNumbers() async {
    try {
      final simCards = (await MobileNumber.getSimCards)!;
      print(simCards);
      final numbers = simCards
          ?.map((sim) => sim.number ?? '')
          .where((number) => number.isNotEmpty)
          .toList();

      if (numbers != null && numbers.isNotEmpty) {
        // SIM card numbers are available, update state or handle them accordingly
        setState(() {
          _simNumbers = numbers;
        });
      } else {
        // No phone number available on any SIM card
        print('No phone number available on any SIM card');
      }
    } catch (e) {
      // Error occurred while fetching SIM card information
      print('Error detecting SIM numbers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detect Available Sims'),
        ),
        body: _hasPhonePermission ? _buildSimList() : _buildPermissionButton());
  }

  Widget _buildSimList() {
    if (_simNumbers.isEmpty) {
      return const Center(
        child: Text('No phone number available on any SIM card'),
      );
    }

    return ListView.builder(
      itemCount: _simNumbers.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_simNumbers[index]),
          leading: const Icon(Icons.sim_card),
        );
      },
    );
  }

  Widget _buildPermissionButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _requestPhonePermission,
        child: const Text('Grant Phone Permission'),
      ),
    );
  }
}
