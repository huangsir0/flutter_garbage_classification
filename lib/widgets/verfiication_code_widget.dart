import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';

// 当前存在的问题是，必须在外部调用的时候给一个初始值
class CodeReview extends StatefulWidget {
  CodeReview({Key key, this.text, this.onTap}) : super(key: key);
  final String text;

  final Function onTap;

  CodeReviewState createState() => CodeReviewState();
}

class CodeReviewState extends State<CodeReview> {
  String _ranStr;
  int _textLength;
  double _width;
  double _height;
  List<Offset> _lineOffsets = <Offset>[];
  Color _ranColor = DzyTheme.randomColor();

  void _randLines() {
    _lineOffsets.clear();
    for (var i = 0; i < _textLength; i++) {
      double fromX = randomBetween(10, 20).toDouble();
      double fromY = randomBetween(3, 33).toDouble();
      Offset from = Offset(fromX, fromY);
      _lineOffsets.add(from);

      double endX = randomBetween(60, _width.toInt() - 10).toDouble();
      double endY = randomBetween(3, 33).toDouble();
      Offset end = Offset(endX, endY);
      _lineOffsets.add(end);
    }
    _ranColor = DzyTheme.randomColor();
  }

  @override
  void initState() {
    super.initState();

    changeData(this.widget.text);
  }

  void changeData(String code) {
    _textLength = widget.text.length ?? 4;
    _width = _textLength.toDouble() * 22;
    _height = 36;
    _ranStr = code;
    print(_ranStr);
    _randLines();
  }

  Container _subString(index) {
    return Container(
      padding: EdgeInsets.only(
          left: 2, right: 2, top: randomBetween(0, 14).toDouble()),
      child: Transform.rotate(
        angle: pi / randomBetween(3, 30) * randomBetween(-1, 1),
        child: Text(_ranStr[index],
            style: TextStyle(
                fontSize: randomBetween(16, 18).toDouble(),
                color: DzyTheme.randomColor())),
      ),
    );
  }

  Container _backLines() {
    // 父类模块和子类模块最少有一个设置大小

    return Container(
      width: _width,
      height: _height,
      child: CustomPaint(
        painter: CodePaint(_lineOffsets, _ranColor, _ranStr),
        foregroundPainter: CodePaint(_lineOffsets, _ranColor, _ranStr),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this.widget.onTap();
      },
      child: Container(
        width: _width,
        height: _height,
        color: Colors.grey[200],
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _backLines(),
            _backLines(),
            Container(
              width: _width,
              height: _height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_textLength, (int index) {
                  return _subString(index);
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CodePaint extends CustomPainter {
  // 暂时没有找获取焦点后页面重绘的监听方法，所以外部传递
  final List<Offset> lineOffsets;
  final Color ranColor;
  final String code;

  CodePaint(this.lineOffsets, this.ranColor, this.code);

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint(canvas.runtimeType.toString());
    canvas.save();
    Paint _paint = Paint()
      ..color = ranColor //画笔颜色
      ..strokeCap = StrokeCap.round //画笔笔触类型
      ..isAntiAlias = true //是否启动抗锯齿
      ..blendMode = BlendMode.exclusion //颜色混合模式
      ..style = PaintingStyle.fill //绘画风格，默认为填充
      ..colorFilter = ColorFilter.mode(ranColor,
          BlendMode.exclusion) //颜色渲染模式，一般是矩阵效果来改变的,但是flutter中只能使用颜色混合模式
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 1.0) //模糊遮罩效果，flutter中只有这个
      ..filterQuality = FilterQuality.high //颜色渲染模式的质量
      // ..strokeWidth = randomBetween(1, 3).toDouble(); // 暂时固定
      ..strokeWidth = 1;

    final pointMode = PointMode.lines;
    canvas.drawPoints(pointMode, lineOffsets, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CodePaint oldDelegate) {
    return oldDelegate.code != this.code;
  }
}

class DzyTheme {
  static Color randomColor() {
    return Color.fromARGB(255, Random().nextInt(256) + 0,
        Random().nextInt(256) + 0, Random().nextInt(256) + 0);
  }
}
