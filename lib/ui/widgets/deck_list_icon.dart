import 'package:forehead_guess/design/fg_colors.dart';
import 'package:forehead_guess/ui/widgets/image_error_placeholder.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import '../../models/deck.model.dart';

class DeckListIcon extends StatelessWidget {
  const DeckListIcon({
    Key? key,
    required this.deck,
    required this.index,
    required this.onPressedDeck,
  }) : super(key: key);

  final Deck deck;
  final int index;
  final Function(int) onPressedDeck;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Ink(
          width: 50,
          height: 50,
          child: InkWell(
            onTap: () => onPressedDeck(index),
            customBorder: const CircleBorder(
              side: BorderSide(width: 1, color: fgWarningColor),
            ),
            child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(deck.image),
                placeholderErrorBuilder: (context, error, stackTrace) {
                  return FGImageErrorPlaceholder(text: deck.name);
                },
                imageErrorBuilder: (context, error, stackTrace) {
                  return FGImageErrorPlaceholder(text: deck.name);
                }),
            splashColor: Colors.red,
          ), // Red will correctly spread over gradient
        ));
  }
}
