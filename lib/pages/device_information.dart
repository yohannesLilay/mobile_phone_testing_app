import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_information/device_information.dart';

class DeviceInformationScreen extends StatefulWidget {
  const DeviceInformationScreen({super.key});

  @override
  State<DeviceInformationScreen> createState() =>
      _DeviceInformationScreenState();
}

class _DeviceInformationScreenState extends State<DeviceInformationScreen> {
  bool _hasPhonePermission = false;
  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "",
      _deviceName = "",
      _productName = "";

  @override
  void initState() {
    super.initState();
    _checkPhonePermission();
  }

  Future<void> _checkPhonePermission() async {
    try {
      final hasPermission = await Permission.phone.request().isGranted;
      setState(() {
        _hasPhonePermission = hasPermission;
      });
      if (!hasPermission) {
        await _requestPhonePermission();
      } else {
        initPlatformState();
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
      initPlatformState();
    } catch (e) {
      print('Error requesting phone permission: $e');
    }
  }

  Future<void> initPlatformState() async {
    late String platformVersion,
        imeiNo = '',
        modelName = '',
        manufacturer = '',
        deviceName = '',
        productName = '';

    // Platform messages may fail,
    // so we use a try/catch PlatformException.
    try {
      platformVersion = await DeviceInformation.platformVersion;
      print(platformVersion);
      imeiNo = await DeviceInformation.deviceIMEINumber;
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
      deviceName = await DeviceInformation.deviceName;
      productName = await DeviceInformation.productName;
    } on PlatformException catch (e) {
      print(e);
      platformVersion = '${e.message}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = "Running on :$platformVersion";
      _imeiNo = imeiNo;
      _modelName = modelName;
      _manufacturerName = manufacturer;
      _deviceName = deviceName;
      _productName = productName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information'),
      ),
      body: _hasPhonePermission ? _buildDeviceInformation() : _buildPermissionButton(),
    );
  }

  Widget _buildDeviceInformation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          Text('$_platformVersion\n'),
          const SizedBox(
            height: 10,
          ),
          Text('IMEI Number: $_imeiNo\n'),
          const SizedBox(
            height: 10,
          ),
          Text('Device Model: $_modelName\n'),
          const SizedBox(
            height: 10,
          ),
          Text('Manufacture Name: $_manufacturerName\n'),
          const SizedBox(
            height: 10,
          ),
          Text('Device Name: $_deviceName\n'),
          const SizedBox(
            height: 10,
          ),
          Text('Product Name: $_productName\n'),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
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
