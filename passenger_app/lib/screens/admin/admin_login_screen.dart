import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../utils/app_colors.dart';
import 'admin_dashboard.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Admin Portal', style: TextStyle(color: AppColors.textPrimary)), backgroundColor: Colors.white, elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.admin_panel_settings, size: 100, color: AppColors.primary),
              const SizedBox(height: 32),
              if (_error != null)
                Container(padding: const EdgeInsets.all(12), color: Colors.red.shade100, child: Text(_error!, style: const TextStyle(color: Colors.red))),
              const SizedBox(height: 16),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Admin Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email))),
              const SizedBox(height: 16),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)), obscureText: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    setState(() { _isLoading = true; _error = null; });
                    try {
                      await Provider.of<AdminProvider>(context, listen: false).login(_emailController.text, _passwordController.text);
                      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
                    } catch (e) {
                      setState(() { _error = e.toString(); });
                    } finally {
                      if (mounted) setState(() { _isLoading = false; });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
