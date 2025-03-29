import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Helper function to launch URLs
  Future<void> _launchUrl(String urlString, BuildContext context) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Could not launch $urlString')),
         );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- App Description Placeholder ---
    const String appDescription =
        'reCall helps you remember to keep in touch with the important people in your life. '
        'Set how often you want to contact someone, mark when you last did, '
        'and get reminders when they\'re due!';
    // --- Team Information Placeholder ---
    const String teamInfo = 'Developed by markbworth.';


    return Scaffold(
      appBar: AppBar(
        title: const Text('About reCall'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // App Description
          const Text(
            'App Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(appDescription),
          const Divider(height: 32),

          // Team Info
          const Text(
            'Development Team',
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(teamInfo),
           const Divider(height: 32),

          // Contact Email
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Contact Developer'),
            subtitle: const Text('markbworth@gmail.com'),
            onTap: () => _launchUrl('mailto:markbworth@gmail.com', context),
          ),

          // Patreon Link (Placeholder)
          ListTile(
            leading: const Icon(Icons.favorite), // Or a specific Patreon icon if desired
            title: const Text('Support on Patreon'),
            subtitle: const Text('Help support future development!'),
            onTap: () => _launchUrl('https://patreon.com/YOUR_USERNAME_HERE', context), // Replace with actual link later
             trailing: const Icon(Icons.open_in_new),
          ),

          // Add more sections like Version Number, Licenses etc. if needed later
        ],
      ),
    );
  }
}