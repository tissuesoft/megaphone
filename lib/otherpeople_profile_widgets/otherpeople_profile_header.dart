import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtherPeopleProfileHeader extends StatefulWidget implements PreferredSizeWidget {
  final String userId;

  const OtherPeopleProfileHeader({
    super.key,
    required this.userId,
  });

  @override
  Size get preferredSize => const Size.fromHeight(69);

  @override
  State<OtherPeopleProfileHeader> createState() => _OtherPeopleProfileHeaderState();
}

class _OtherPeopleProfileHeaderState extends State<OtherPeopleProfileHeader> {
  String userNickname = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserNickname();
  }

  Future<void> fetchUserNickname() async {
    final supabase = Supabase.instance.client;

    try {
      final userData = await supabase
          .from('Users')
          .select('user_nickname')
          .eq('user_id', widget.userId)
          .maybeSingle();

      setState(() {
        userNickname = userData?['user_nickname'] ?? '알 수 없음';
        isLoading = false;
      });
    } catch (e) {
      print('❌ 유저 닉네임 불러오기 실패: $e');
      setState(() {
        userNickname = '알 수 없음';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      bottom: false,
      child: Container(
        height: 69,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 가운데 "고확왕 userNickname 프로필"
            isLoading
                ? const CircularProgressIndicator()
                : Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: userNickname,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                  const TextSpan(
                    text: ' 프로필',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),

            // 왼쪽 뒤로가기 버튼
            Positioned(
              left: screenWidth * 0.04,
              top: (69 - 44) / 2,
              child: SizedBox(
                width: 34,
                height: 44,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF4B5563),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
