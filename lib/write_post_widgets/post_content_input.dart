import 'package:flutter/material.dart';

class PostContentInput extends StatefulWidget {
  final Function(String) onChanged;

  const PostContentInput({super.key, required this.onChanged});

  @override
  State<PostContentInput> createState() => _PostContentInputState();
}

class _PostContentInputState extends State<PostContentInput> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;
  final int _maxLength = 100;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _charCount = _controller.text.length;
      });
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/kimyongsik.jpg'),
              ),
              SizedBox(width: 12),
              Text(
                '닉네임',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 128,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _controller,
              maxLines: null,
              maxLength: _maxLength,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: '글 내용을 입력하세요',
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFADAEBC),
                ),
              ),
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$_charCount / $_maxLength자',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
