import 'package:flutter/material.dart';
import 'package:forehead_guess/design/fg_colors.dart';
import 'package:forehead_guess/design/fg_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FGText extends StatelessWidget {
  final String text;
  final TextStyle style;
  TextAlign align = TextAlign.left;
  int maxLines = 1;

  FGText.headingOne(this.text, {Key? key, Color color = fgDarkColor})
      : style = heading1Style.copyWith(color: color),
        super(key: key);
  FGText.headingThree(this.text, {Key? key, Color color = fgGreyColor})
      : style = heading1Style.copyWith(color: color),
        super(key: key);
  FGText.headingTwo(this.text, {Key? key, Color color = fgPrimaryColorLight})
      : style = heading1Style.copyWith(color: color),
        super(key: key);
  FGText.subheading(this.text, {Key? key, Color color = fgPrimaryColorLight})
      : style = subheadingStyle.copyWith(color: color),
        super(key: key);

  FGText.caption(this.text, {Key? key, Color color = fgWarningColor})
      : style = heading1Style.copyWith(color: color),
        super(key: key);

  FGText.resultwordCorrect(this.text, {Key? key, Color color = fgDarkColor})
      : style = heading1Style.copyWith(color: color),
        super(key: key);

  FGText.resultwordInorrect(this.text, {Key? key, Color color = fgWarningColor})
      : style = heading1Style.copyWith(color: color),
        super(key: key);

  FGText.timerStyle(this.text, {Key? key, Color color = fgWarningColor})
      : style = subheadingStyle.copyWith(color: color),
        super(key: key);

  FGText.warningText(this.text,
      {Key? key,
      Color color = fgWarningColor,
      this.maxLines = 1,
      this.align = TextAlign.left})
      : style = heading1Style.copyWith(color: color),
        super(key: key);

  FGText.body(this.text,
      {Key? key,
      Color color = fgDarkColor,
      this.maxLines = 1,
      this.align = TextAlign.left})
      : style = bodyStyle.copyWith(color: color),
        super(key: key);

  FGText.settingsHeading(this.text, {Key? key, Color color = fgDarkColor})
      : style = headlineStyle.copyWith(color: color),
        super(key: key);

  FGText.unknownDeckName(this.text, {Key? key, Color color = fgDarkColor})
      : style = headlineStyle.copyWith(color: color),
        align = TextAlign.center,
        super(key: key);

  FGText.bigWord(this.text,
      {Key? key,
      Color color = fgGreyColor,
      this.maxLines = 1,
      this.align = TextAlign.left})
      : style = bigWordStyle.copyWith(color: color),
        super(key: key);

  FGText.bodyPrimary(this.text, {Key? key, Color color = fgPrimaryColor})
      : style = bodyStyleExtraBold.copyWith(color: color),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: style,
      maxLines: maxLines,
      textAlign: align,
    );
  }
}
