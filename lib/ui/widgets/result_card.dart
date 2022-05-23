import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forehead_guess/main.dart';

import '../../design/fg_design.dart';
import '../../util/constants.dart';
import 'empty_placeholder.dart';

class FGResultCard extends ConsumerWidget {
  const FGResultCard({
    Key? key,
    required this.color,
    required this.sideColor,
  }) : super(key: key);

  final Color color;
  final Color sideColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, bool> resultWords =
        ref.watch(decksService).getResultWords();

    return resultWords.isEmpty
        ? const EmptyPlaceholder()
        : Container(
            margin: const EdgeInsets.fromLTRB(
                Constant.paddingResultCard, 0, Constant.paddingResultCard, 0),
            decoration: BoxDecoration(
                color: fgPrimaryColor,
                border: Border.all(
                  color: sideColor,
                  width: Constant.borderWidthBig,
                ),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 2,
                    spreadRadius: 2,
                    color: Colors.black26,
                  ),
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Constant.borderRadiusBig),
                    topRight: Radius.circular(Constant.borderRadiusBig))),
            child: Padding(
                padding: EdgeInsets.all(Constant.paddingResultCard),
                child: Center(
                    child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FGText.headingOne(
                        'Results: 😊 ',
                      ),
                      FGText.resultwordCorrect(
                          '${ref.watch(decksService).getWordCountCorrect()}'),
                      FGText.headingOne(' 🙃 '),
                      FGText.resultwordInorrect(
                          '${ref.watch(decksService).getWordCountIncorrect()}')
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: resultWords.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 50,
                              child: Center(
                                  child: resultWords.values.elementAt(index)
                                      ? FGText.resultwordCorrect(
                                          resultWords.keys.elementAt(index))
                                      : FGText.resultwordInorrect(
                                          resultWords.keys.elementAt(index))),
                            );
                          })),
                ]))),
          );
  }
}
