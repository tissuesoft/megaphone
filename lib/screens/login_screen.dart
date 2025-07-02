import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'registar_screen.dart';
import 'bottom_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> kakaoLogin() async {
    try {
      OAuthToken token;

      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      final kakaoUser = await UserApi.instance.me();
      final kakaoId = kakaoUser.id.toString();
      print('🟡 카카오 로그인 완료. 유저 ID: $kakaoId');

      final supabase = Supabase.instance.client;

      final existingUser = await supabase
          .from('Users')
          .select()
          .eq('kakao_id', kakaoId)
          .maybeSingle();
      print('🟢 Supabase에서 조회한 유저: $existingUser');

      if (existingUser != null) {
        // ✅ 이미 가입된 유저 → 바로 홈으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const BottomNavScreen(initialIndex: 0),
          ),
        );
      } else {
        // ❗️회원가입 안된 유저 → 닉네임 설정 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RegistarScreen(kakaoId: kakaoId),
          ),
        );
      }
      if (existingUser != null) {
        print('✅ 기존 유저 → 홈 이동');
      } else {
      print('🆕 신규 유저 → RegistarScreen 이동');
      }
    } catch (e) {
      print('❌ 카카오 로그인 실패: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final iconTop = screenHeight * 0.28;
    final iconSize = screenWidth * 0.6;
    final textTop = iconTop + iconSize - screenHeight * 0.07;
    final fontSizeTitle = screenWidth * 0.075;
    final fontSizeSubtitle = screenWidth * 0.035;
    final kakaoBtnHeight = screenHeight * 0.055;
    final kakaoFontSize = screenWidth * 0.035;
    final kakaoIconSize = screenWidth * 0.035;
    final termsFontSize = screenWidth * 0.03;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFB923C), Color(0xFFF87171)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // ✅ 둥둥 떠있는 아이콘
              Positioned(
                top: iconTop,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _floatAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: Image.asset(
                        'assets/login_megaphone_icon.png',
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),

              // ✅ 타이틀 텍스트
              Positioned(
                top: textTop,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      '고성능 확성기',
                      style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        letterSpacing: -1.25,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Text(
                      '모두에게 전하는 한마디',
                      style: TextStyle(
                        fontSize: fontSizeSubtitle,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: const Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ 카카오 로그인 버튼
              Positioned(
                bottom: screenHeight * 0.33,
                left: screenWidth * 0.12,
                right: screenWidth * 0.12,
                child: GestureDetector(
                  onTap: kakaoLogin,
                  child: Container(
                    height: kakaoBtnHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE500),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(0, 10),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: screenWidth * 0.04,
                          top: kakaoBtnHeight * 0.5 - kakaoIconSize / 2,
                          child: Image.asset(
                            'assets/kakao_icon.png',
                            width: kakaoIconSize,
                            height: kakaoIconSize,
                          ),
                        ),
                        Text(
                          '카카오 로그인',
                          style: TextStyle(
                            fontSize: kakaoFontSize,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'NotoSansKR',
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ✅ 약관 안내 텍스트
              Positioned(
                bottom: screenHeight * 0.03,
                left: 0,
                right: 0,
                child: Text(
                  '로그인하면 서비스 이용약관 및\n개인정보처리방침에 동의하는 것으로 간주됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: termsFontSize,
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
