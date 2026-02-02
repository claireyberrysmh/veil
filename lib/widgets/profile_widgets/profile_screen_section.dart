import 'package:flutter/material.dart';
import 'user_card.dart';
import 'custom_text_field.dart';
import 'security_toggle.dart';

class ProfileScreenSection extends StatefulWidget {
  const ProfileScreenSection({super.key});

  @override
  State<ProfileScreenSection> createState() => _ProfileScreenSectionState();
}

class _ProfileScreenSectionState extends State<ProfileScreenSection> {
  bool _twoFactorEnabled = true;
  bool _emailNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage your account settings',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            const UserCard(name: 'John Doe', email: 'john.doe@example.com'),
            const SizedBox(height: 28),
            const Text(
              'Account Settings',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const CustomTextField(label: 'Email', hint: 'john.doe@example.com'),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Password',
              hint: 'Enter new password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Confirm Password',
              hint: 'Confirm new password',
              obscureText: true,
            ),
            const SizedBox(height: 28),
            const Text(
              'Security',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SecurityToggle(
              title: 'Two-Factor Authentication',
              description: 'Add extra security to your account',
              value: _twoFactorEnabled,
              onChanged: (value) => setState(() => _twoFactorEnabled = value),
            ),
            const SizedBox(height: 12),
            SecurityToggle(
              title: 'Email Notifications',
              description: 'Receive alerts via email',
              value: _emailNotificationsEnabled,
              onChanged: (value) =>
                  setState(() => _emailNotificationsEnabled = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: Colors.white12),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
