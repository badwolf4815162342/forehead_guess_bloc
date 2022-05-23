import 'package:flutter/material.dart';
import 'package:forehead_guess/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forehead_guess/ui/widgets/image_error_placeholder.dart';
import 'package:forehead_guess/util/constants.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../design/fg_design.dart';
import 'empty_placeholder.dart';

class DeckImage extends ConsumerWidget {
  const DeckImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, bool> resultWords =
        ref.watch(decksService).getResultWords();
    return resultWords.isNotEmpty
        ? EmptyPlaceholder()
        : Padding(
            padding: const EdgeInsets.all(Constant.paddingResultCard * 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Constant.borderRadiusBig),
              child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(ref.read(decksService).currentDeck.image),
                  placeholderErrorBuilder: (context, error, stackTrace) {
                    return FGImageErrorPlaceholder(
                        text: ref.read(decksService).currentDeck.name);
                  },
                  imageErrorBuilder: (context, error, stackTrace) {
                    return FGImageErrorPlaceholder(
                        text: ref.read(decksService).currentDeck.name);
                  }),
            ));
  }
}
