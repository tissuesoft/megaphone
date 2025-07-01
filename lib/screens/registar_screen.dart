import 'package:flutter/material.dart';
import '../registar_widgets/registar_header.dart';
import '../registar_widgets/registar_body.dart';
import '../registar_widgets/registar_footer.dart';

class RegistarScreen extends StatefulWidget {
  const RegistarScreen({super.key});

  @override
  State<RegistarScreen> createState() => _RegistarScreenState();
}

class _RegistarScreenState extends State<RegistarScreen> {
  bool isNicknameAvailable = false;

  void updateNicknameStatus(bool available) {
    setState(() {
      isNicknameAvailable = available;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFF6B35),
      body: SafeArea(
        child: Column(
          children: [
            const RegistarHeader(),
            Expanded(
              child: RegistarBody(
                onNicknameAvailableChanged: updateNicknameStatus,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RegistarFooter(
        isNicknameAvailable: isNicknameAvailable,
      ),
    );
  }
}
