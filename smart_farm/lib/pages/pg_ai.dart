import 'package:flutter/material.dart';
import 'package:smart_farm/pages/app_widgets.dart';

class AppPageAI extends StatefulWidget {
  const AppPageAI({super.key});

  @override
  State<AppPageAI> createState() => _AppPageAIState();
}

class _AppPageAIState extends State<AppPageAI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Chẩn bệnh"),
      body: Container(
        child: const Center(
          child: Text('AI Page'),
        ),
      ),
    );
  }
}
