import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostHeader extends StatefulWidget implements PreferredSizeWidget {
  final dynamic postData;
  final VoidCallback onDelete;

  const PostHeader({
    super.key,
    required this.postData,
    required this.onDelete,
  });

  @override
  State<PostHeader> createState() => _PostHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(69);
}

class _PostHeaderState extends State<PostHeader> {
  final GlobalKey _menuIconKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  String? myUserId;
  String? writerUserId;

  @override
  void initState() {
    super.initState();
    loadUserIds();
  }

  Future<void> loadUserIds() async {
    try {
      final kakaoUser = await UserApi.instance.me();
      final usersMap = widget.postData['Users'];
      print(kakaoUser);
      print('kakaoUser');


      if (usersMap == null) {
        print('❌ postData["Users"] is null');
        return;
      }

      setState(() {
        myUserId = kakaoUser.id.toString();
        writerUserId = usersMap['kakao_id']?.toString();
        print('🟡 myUserId: $myUserId');
        print('🟢 writerUserId: $writerUserId');
      });
    } catch (e) {
      print('❌ 사용자 ID 불러오기 실패: $e');
    }
  }

  Future<void> deletePost() async {
    final boardId = widget.postData['board_id'];
    try {
      final kakaoIdInt = int.parse(myUserId!); // 👈 String → int

      print('🧾 삭제 요청 board_id: $boardId, kakao_id: $kakaoIdInt');

      final response = await Supabase.instance.client
          .from('Board')
          .delete()
          .eq('board_id', boardId)
          .eq('kakao_id', kakaoIdInt) // 👈 정확한 타입으로 비교
          .select();

      print('✅ 삭제 완료: $response');
      widget.onDelete();
    } catch (e) {
      print('❌ 게시글 삭제 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('게시글 삭제에 실패했습니다.')),
      );
    }
  }



  void _showDeletePopup() async {
    if (myUserId == null || writerUserId == null) {
      print('❗ 사용자 정보 로딩 전');
      return;
    }

    if (myUserId != writerUserId) {
      print('❌ 작성자 아님: 삭제 불가');
      return;
    }

    final RenderBox renderBox = _menuIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: offset.dy + renderBox.size.height,
          left: offset.dx + renderBox.size.width - 86,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () async {
                _overlayEntry?.remove();
                _overlayEntry = null;

                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('게시글 삭제'),
                    content: const Text('정말 삭제하시겠습니까?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
                    ],
                  ),
                );

                if (confirm == true) {
                  await deletePost();
                }
              },
              child: Container(
                width: 90,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete_outline,
                      color: Color(0xFFDC2626),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '삭제',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _toggleDeletePopup() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    } else {
      _showDeletePopup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: widget.preferredSize.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 8,
              top: 12,
              child: SizedBox(
                width: 31.75,
                height: 44,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF374151),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            const Text(
              '게시글 상세',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 28 / 18,
                color: Color(0xFF111827),
              ),
            ),
            Positioned(
              right: 8,
              top: 12,
              child: GestureDetector(
                key: _menuIconKey,
                onTap: _toggleDeletePopup,
                child: const SizedBox(
                  width: 31.75,
                  height: 44,
                  child: Icon(
                    Icons.more_vert,
                    size: 18,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
