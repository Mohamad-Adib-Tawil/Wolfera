import 'package:flutter/material.dart';
import 'package:wolfera/test_notification_helper.dart';

/// صفحة اختبار سريع للإشعارات
class QuickTestPage extends StatefulWidget {
  const QuickTestPage({super.key});

  @override
  State<QuickTestPage> createState() => _QuickTestPageState();
}

class _QuickTestPageState extends State<QuickTestPage> {
  final _carIdController = TextEditingController();
  String _output = '';

  void _addOutput(String text) {
    setState(() {
      _output += '$text\n';
    });
    print(text); // أيضاً في console
  }

  Future<void> _runFullTest() async {
    if (_carIdController.text.isEmpty) {
      _addOutput('❌ Please enter Car ID');
      return;
    }

    _addOutput('🔬 Starting full notification test...');
    await TestNotificationHelper.fullNotificationTest(_carIdController.text);
    _addOutput('✅ Full test completed - check console for details');
  }

  Future<void> _checkFCMToken() async {
    _addOutput('📱 Checking FCM token status...');
    await TestNotificationHelper.checkFCMTokenStatus();
    _addOutput('✅ FCM check completed - check console for details');
  }

  Future<void> _addToFavorites() async {
    if (_carIdController.text.isEmpty) {
      _addOutput('❌ Please enter Car ID');
      return;
    }

    _addOutput('➕ Adding car to favorites...');
    await TestNotificationHelper.addCarToFavorites(_carIdController.text);
    _addOutput('✅ Added to favorites');
  }

  Future<void> _testPriceChange() async {
    if (_carIdController.text.isEmpty) {
      _addOutput('❌ Please enter Car ID');
      return;
    }

    _addOutput('💰 Testing price change notification...');
    await TestNotificationHelper.testPriceChangeForCar(_carIdController.text);
    _addOutput('✅ Price change test completed');
  }

  void _clearOutput() {
    setState(() {
      _output = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Notification Test'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Car ID Input
            TextField(
              controller: _carIdController,
              decoration: const InputDecoration(
                labelText: 'Car ID',
                hintText: 'Enter the car ID to test',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick Actions
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _runFullTest,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Full Test'),
                ),
                ElevatedButton(
                  onPressed: _checkFCMToken,
                  child: const Text('Check FCM'),
                ),
                ElevatedButton(
                  onPressed: _addToFavorites,
                  child: const Text('Add to Favorites'),
                ),
                ElevatedButton(
                  onPressed: _testPriceChange,
                  child: const Text('Test Price Change'),
                ),
                ElevatedButton(
                  onPressed: _clearOutput,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Output Area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _output.isEmpty ? 'Test output will appear here...' : _output,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            
            // Instructions
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Test Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. Enter the Car ID from the second device'),
                  Text('2. Click "Full Test" to run complete test'),
                  Text('3. Or use individual buttons for specific tests'),
                  Text('4. Check console logs for detailed output'),
                  SizedBox(height: 8),
                  Text(
                    'Car ID: 165f0984-46d5-4f74-a44f-239d6e511c3e',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _carIdController.dispose();
    super.dispose();
  }
}
