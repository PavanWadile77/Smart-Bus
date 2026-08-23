import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';

class NotificationManagementScreen extends StatefulWidget {
  const NotificationManagementScreen({Key? key}) : super(key: key);

  @override
  State<NotificationManagementScreen> createState() => _NotificationManagementScreenState();
}

class _NotificationManagementScreenState extends State<NotificationManagementScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _bodyController, decoration: const InputDecoration(labelText: 'Message Body', border: OutlineInputBorder()), maxLines: 3),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  if (_titleController.text.isEmpty || _bodyController.text.isEmpty) return;
                  setState(() => _isLoading = true);
                  await Provider.of<AdminProvider>(context, listen: false).sendNotification({
                    'title': _titleController.text,
                    'body': _bodyController.text,
                    'target': 'all',
                  });
                  if (mounted) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification Sent!')));
                    _titleController.clear();
                    _bodyController.clear();
                  }
                },
                child: _isLoading ? const CircularProgressIndicator() : const Text('Broadcast to All Users'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
