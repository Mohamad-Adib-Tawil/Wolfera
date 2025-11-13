import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/services/chat_service.dart';
import 'package:wolfera/services/supabase_service.dart';

class ChatDebugPage extends StatefulWidget {
  const ChatDebugPage({super.key});

  @override
  State<ChatDebugPage> createState() => _ChatDebugPageState();
}

class _ChatDebugPageState extends State<ChatDebugPage> {
  final _chatService = GetIt.I<ChatService>();
  String _output = '';
  bool _isLoading = false;

  void _addOutput(String text) {
    setState(() {
      _output += '$text\n';
    });
    print(text);
  }

  Future<void> _testGetConversations() async {
    setState(() {
      _isLoading = true;
      _output = '';
    });

    _addOutput('🧪 Testing getUserConversations...');
    
    final user = SupabaseService.currentUser;
    if (user == null) {
      _addOutput('❌ No current user');
      setState(() => _isLoading = false);
      return;
    }

    _addOutput('👤 Current user: ${user.id}');
    _addOutput('📧 User email: ${user.email}');

    try {
      // Test basic connection
      _addOutput('🔍 Testing basic Supabase connection...');
      final testQuery = await SupabaseService.client
          .from('conversations')
          .select('count')
          .count();
      _addOutput('✅ Basic connection works. Total conversations in DB: $testQuery');

      // Test user-specific query
      _addOutput('🔍 Testing user-specific conversations query...');
      final conversations = await _chatService.getUserConversations(user.id);
      _addOutput('📊 Found ${conversations.length} conversations for user');

      if (conversations.isEmpty) {
        _addOutput('⚠️ No conversations found. Let\'s check why...');
        
        // Check if user exists in any conversations
        final allConversations = await SupabaseService.client
            .from('conversations')
            .select('id,buyer_id,seller_id,is_active,created_at')
            .or('buyer_id.eq.${user.id},seller_id.eq.${user.id}');
        
        _addOutput('🔍 Total conversations involving user: ${allConversations.length}');
        
        for (final conv in allConversations) {
          _addOutput('   - Conv ${conv['id']}: buyer=${conv['buyer_id']}, seller=${conv['seller_id']}, active=${conv['is_active']}');
        }

        // Check if user has any cars
        final userCars = await SupabaseService.client
            .from('cars')
            .select('id,title,user_id')
            .eq('user_id', user.id);
        _addOutput('🚗 User has ${userCars.length} cars');

        // Check if there are any conversations at all
        final totalConversations = await SupabaseService.client
            .from('conversations')
            .select('id,buyer_id,seller_id,is_active')
            .limit(5);
        _addOutput('🌍 Sample conversations in DB: ${totalConversations.length}');
        for (final conv in totalConversations) {
          _addOutput('   - Conv ${conv['id']}: buyer=${conv['buyer_id']}, seller=${conv['seller_id']}, active=${conv['is_active']}');
        }
      } else {
        _addOutput('✅ Conversations found:');
        for (final conv in conversations) {
          _addOutput('   - ${conv['id']}: buyer=${conv['buyer_id']}, seller=${conv['seller_id']}');
          _addOutput('     Last message: "${conv['last_message'] ?? 'None'}"');
          _addOutput('     Car: ${conv['car']?['title'] ?? 'Unknown'}');
        }
      }

    } catch (e, stackTrace) {
      _addOutput('❌ Error: $e');
      _addOutput('📍 Stack trace: $stackTrace');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _testCreateConversation() async {
    setState(() {
      _isLoading = true;
      _output = '';
    });

    _addOutput('🧪 Testing conversation creation...');
    
    final user = SupabaseService.currentUser;
    if (user == null) {
      _addOutput('❌ No current user');
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Get a car to test with
      final cars = await SupabaseService.client
          .from('cars')
          .select('id,title,user_id')
          .neq('user_id', user.id)
          .limit(1);

      if (cars.isEmpty) {
        _addOutput('❌ No cars from other users found to test with');
        setState(() => _isLoading = false);
        return;
      }

      final testCar = cars.first;
      _addOutput('🚗 Using test car: ${testCar['title']} (${testCar['id']})');
      _addOutput('👤 Car owner: ${testCar['user_id']}');

      // Try to create/get conversation
      final conversation = await _chatService.getOrCreateConversation(
        carId: testCar['id'],
        buyerId: user.id,
        sellerId: testCar['user_id'],
      );

      if (conversation != null) {
        _addOutput('✅ Conversation created/found: ${conversation['id']}');
        _addOutput('   Buyer: ${conversation['buyer_id']}');
        _addOutput('   Seller: ${conversation['seller_id']}');
        _addOutput('   Car: ${conversation['car_id']}');
        _addOutput('   Active: ${conversation['is_active']}');
      } else {
        _addOutput('❌ Failed to create conversation');
      }

    } catch (e, stackTrace) {
      _addOutput('❌ Error: $e');
      _addOutput('📍 Stack trace: $stackTrace');
    }

    setState(() => _isLoading = false);
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
        title: const Text('Chat Debug'),
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
                  onPressed: _isLoading ? null : _testGetConversations,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Test Get Conversations'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testCreateConversation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Test Create Conversation'),
                ),
                ElevatedButton(
                  onPressed: _clearOutput,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Clear Output'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Loading indicator
            if (_isLoading)
              const LinearProgressIndicator(),
            
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
                    'Chat Debug Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. Click "Test Get Conversations" to check if conversations load'),
                  Text('2. Click "Test Create Conversation" to test conversation creation'),
                  Text('3. Check console logs for detailed output'),
                  Text('4. Look for RLS errors or missing data'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
