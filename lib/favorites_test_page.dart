import 'package:flutter/material.dart';
import 'package:wolfera/favorites_fix_helper.dart';

/// صفحة اختبار وإصلاح المفضلة
class FavoritesTestPage extends StatefulWidget {
  const FavoritesTestPage({super.key});

  @override
  State<FavoritesTestPage> createState() => _FavoritesTestPageState();
}

class _FavoritesTestPageState extends State<FavoritesTestPage> {
  String _output = '';

  void _addOutput(String text) {
    setState(() {
      _output += '$text\n';
    });
    print(text);
  }

  Future<void> _runFullTest() async {
    _addOutput('🧪 Starting full favorites test...');
    await FavoritesFixHelper.fullFavoritesTest();
    _addOutput('✅ Full test completed - check console for details');
  }

  Future<void> _addToFavorites() async {
    _addOutput('➕ Adding car to favorites...');
    await FavoritesFixHelper.addCarToFavoritesDirect();
    _addOutput('✅ Car added to favorites');
  }

  Future<void> _checkStatus() async {
    _addOutput('🔍 Checking favorites status...');
    await FavoritesFixHelper.checkFavoritesStatus();
    _addOutput('✅ Status check completed');
  }

  Future<void> _clearFavorites() async {
    _addOutput('🧹 Clearing all favorites...');
    await FavoritesFixHelper.clearAllFavoritesForCar();
    _addOutput('✅ Favorites cleared');
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
        title: const Text('Favorites Fix & Test'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Action Buttons
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
                  onPressed: _addToFavorites,
                  child: const Text('Add to Favorites'),
                ),
                ElevatedButton(
                  onPressed: _checkStatus,
                  child: const Text('Check Status'),
                ),
                ElevatedButton(
                  onPressed: _clearFavorites,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Clear All'),
                ),
                ElevatedButton(
                  onPressed: _clearOutput,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Clear Output'),
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
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorites Fix Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. Click "Full Test" to run complete test & fix'),
                  Text('2. Or use individual buttons for specific actions'),
                  Text('3. Check console logs for detailed output'),
                  Text('4. After adding to favorites, test price changes'),
                  SizedBox(height: 8),
                  Text(
                    'Target Car: 2024 Nissan X',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  Text(
                    'ID: 165f0984-46d5-4f74-a44f-239d6e511c3e',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: Colors.grey,
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
}
