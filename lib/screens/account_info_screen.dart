import 'package:flutter/material.dart';
import '../setting_widgets/account_info_header.dart';
import '../setting_widgets/account_profile_image.dart';
import '../setting_widgets/account_id_input.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AccountInfoHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: const [
            SizedBox(height: 24),
            ProfileImageSection(),
            SizedBox(height: 48),
            IdInputSection(),
          ],
        ),
      ),
    );
  }
}
