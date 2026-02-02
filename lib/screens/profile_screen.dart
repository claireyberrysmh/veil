import 'package:flutter/material.dart';
import '../widgets/profile_widgets/profile_screen_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const ProfileScreenSection();
  }
}
