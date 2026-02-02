import 'package:flutter/material.dart';
import '../widgets/home_widgets/home_screen_section.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenDetails;
  const HomeScreen({super.key, this.onOpenDetails});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return HomeScreenSection(onOpenDetails: onOpenDetails);
  }
}
