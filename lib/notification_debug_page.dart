import 'package:flutter/material.dart';
import 'package:wolfera/services/notification_debug_helper.dart';
import 'package:wolfera/services/supabase_service.dart';
import 'package:wolfera/services/notification_service.dart';

/// صفحة تشخيص الإشعارات - للاختبار فقط
class NotificationDebugPage extends StatefulWidget {
  const NotificationDebugPage({super.key});

  @override
  State<NotificationDebugPage> createState() => _NotificationDebugPageState();
}

class _NotificationDebugPageState extends State<NotificationDebugPage> {
  final _userIdController = TextEditingController();
  final _carIdController = TextEditingController();
  String _debugOutput = '';

  @override
  void initState() {
    super.initState();
    // تعيين ID المستخدم الحالي كقيمة افتراضية
    final currentUser = SupabaseService.currentUser;
    if (currentUser != null) {
      _userIdController.text = currentUser.id;
    }
  }

  void _addToOutput(String text) {
    setState(() {
      _debugOutput += '$text\n';
    });
  }

  Future<void> _debugUserNotifications() async {
    if (_userIdController.text.isEmpty) {
      _addToOutput('❌ Please enter User ID');
      return;
    }

    _addToOutput('🔍 Starting user notifications debug...');
    await NotificationDebugHelper.debugUserNotifications(_userIdController.text);
    _addToOutput('✅ Debug completed - check console for details');
  }

  Future<void> _debugCarFavorites() async {
    if (_carIdController.text.isEmpty) {
      _addToOutput('❌ Please enter Car ID');
      return;
    }

    _addToOutput('🚗 Starting car favorites debug...');
    await NotificationDebugHelper.debugCarFavorites(_carIdController.text);
    _addToOutput('✅ Debug completed - check console for details');
  }

  Future<void> _testNotification() async {
    if (_userIdController.text.isEmpty) {
      _addToOutput('❌ Please enter User ID');
      return;
    }

    _addToOutput('🧪 Sending test notification...');
    await NotificationDebugHelper.testNotificationForUser(_userIdController.text);
    _addToOutput('✅ Test notification sent - check console for results');
  }

  Future<void> _testPriceChangeNotification() async {
    if (_carIdController.text.isEmpty) {
      _addToOutput('❌ Please enter Car ID');
      return;
    }

    _addToOutput('💰 Testing price change notification...');
    
    try {
      await NotificationService.sendPriceChangeNotification(
        carId: _carIdController.text,
        carTitle: 'Test Car - تجربة السيارة',
        oldPrice: '100',
        newPrice: '150',
      );
      _addToOutput('✅ Price change notification test completed');
    } catch (e) {
      _addToOutput('❌ Error: $e');
    }
  }

  void _clearOutput() {
    setState(() {
      _debugOutput = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Debug'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User ID Input
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                hintText: 'Enter user ID to debug',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Car ID Input
            TextField(
              controller: _carIdController,
              decoration: const InputDecoration(
                labelText: 'Car ID',
                hintText: 'Enter car ID to debug',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _debugUserNotifications,
                  child: const Text('Debug User'),
                ),
                ElevatedButton(
                  onPressed: _debugCarFavorites,
                  child: const Text('Debug Car'),
                ),
                ElevatedButton(
                  onPressed: _testNotification,
                  child: const Text('Test Notification'),
                ),
                ElevatedButton(
                  onPressed: _testPriceChangeNotification,
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
                    _debugOutput.isEmpty ? 'Debug output will appear here...' : _debugOutput,
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
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. Enter your User ID (auto-filled if logged in)'),
                  Text('2. Enter a Car ID that you have in favorites'),
                  Text('3. Click "Debug User" to check your notifications'),
                  Text('4. Click "Debug Car" to see who favorited the car'),
                  Text('5. Click "Test Notification" to send a test notification'),
                  Text('6. Check the console/logs for detailed output'),
                  SizedBox(height: 8),
                  Text(
                    'Note: Make sure you have the car in your favorites before testing!',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.orange,
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
    _userIdController.dispose();
    _carIdController.dispose();
    super.dispose();
  }
}
