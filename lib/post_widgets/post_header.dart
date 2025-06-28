import 'package:flutter/material.dart';

class PostHeader extends StatefulWidget implements PreferredSizeWidget {
  const PostHeader({super.key});

  @override
  State<PostHeader> createState() => _PostHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(69);
}

class _PostHeaderState extends State<PostHeader> {
  final GlobalKey _menuIconKey = GlobalKey(); // 점 3개 아이콘 위치 확인용
  OverlayEntry? _overlayEntry;

  void _showDeletePopup() {
    final RenderBox renderBox = _menuIconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: offset.dy + renderBox.size.height + 0, // 아이콘 아래에 위치
          left: offset.dx + renderBox.size.width - 86, // 오른쪽 정렬
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('삭제 버튼 클릭됨')),
                );
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
                      color: Color(0xFFDC2626), // 빨간 느낌 강조
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '삭제',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDC2626), // 빨간 텍스트
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
            // ← 뒤로가기 버튼
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

            // 📝 중앙 타이틀
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

            // ⋮ 옵션 버튼
            Positioned(
              right: 8,
              top: 12,
              child: GestureDetector(
                key: _menuIconKey, // 위치 측정용
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
