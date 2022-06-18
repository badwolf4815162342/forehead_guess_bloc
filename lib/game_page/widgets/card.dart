import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design/fg_design.dart';
import '../../main.dart';
import '../../util/constants.dart';

class FGCard extends ConsumerStatefulWidget {
  static final routeName = (FGCard).toString();

  final Color color;
  final Color sideColor;
  final String text;
  const FGCard({
    Key? key,
    required this.color,
    required this.sideColor,
    this.text = '',
  }) : super(key: key);

  @override
  ConsumerState<FGCard> createState() => _FGCardState();
}

class _FGCardState extends ConsumerState<FGCard> {
  String _text = '';

  @override
  void initState() {
    super.initState();
    if (widget.text == '') {
      _text = ref.read(decksService).currentWord;
    } else {
      _text = widget.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(Constant.borderRadiusBig),
          child: Center(
              child: FGText.bigWord(
            _text,
            maxLines: 3,
            align: TextAlign.center,
          ))),
      color: widget.color,
      elevation: 8,
      margin: const EdgeInsets.fromLTRB(
          Constant.paddingWordCard,
          Constant.paddingWordCard,
          Constant.paddingWordCard,
          Constant.paddingResultCard),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.borderRadiusBig),
          borderSide: BorderSide(
              color: widget.sideColor, width: Constant.borderWidthBig)),
    );
  }
}
