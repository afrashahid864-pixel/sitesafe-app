import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SiteSafeApp());
}

class SiteSafeApp extends StatelessWidget {
  const SiteSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiteSafe',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String _result = "Enter a website URL to check";

  Future<void> _checkWebsite() async {
    String url = _urlController.text;
    if (!url.startsWith('http')) {
      url = 'https://' + url;
    }
    
    setState(() {
      _result = "Checking...";
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _result = "✅ Safe: Website is online!\nStatus Code: ${response.statusCode}";
        });
      } else {
        setState(() {
          _result = "⚠️ Warning: Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "❌ Error: Could not reach website";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SiteSafe - Website Checker')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter Website URL',
                hintText: 'google.com',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkWebsite,
              child: const Text('Check Safety'),
            ),
            const SizedBox(height: 20),
            Text(_result, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
