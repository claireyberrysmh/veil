import 'package:flutter/material.dart';
import '../widgets/profile_widgets/profile_screen_section.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ProfileScreenSection(onLogout: widget.onLogout);
  }
}
