import 'package:flutter/material.dart';
import '../../design/fg_design.dart';
import '../../design/fg_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forehead_guess/deck_edit_page/deck_edit.page.dart';
import 'package:decks_repository/decks_repository.dart';

class DeckEditPage extends StatelessWidget {
  const DeckEditPage({Key? key}) : super(key: key);

  static Route<void> route({Deck? initialDeck}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => DeckEditBloc(
          decksRepository: context.read<DecksRepository>(),
          initialDeck: initialDeck,
        ),
        child: const DeckEditPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeckEditBloc, DeckEditState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == DeckEditStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const DeckEditView(),
    );
  }
}

class DeckEditView extends StatelessWidget {
  const DeckEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((DeckEditBloc bloc) => bloc.state.status);
    final isNewTodo = context.select(
      (DeckEditBloc bloc) => bloc.state.isNewDeck,
    );
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewTodo ? "Create new Deck" : "Edit Deck",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Save Deck Tooltip",
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<DeckEditBloc>().add(const DeckEditSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                _DecknameField(),
                _ImageUrlField(),
                _WordsField()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DecknameField extends StatelessWidget {
  const _DecknameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DeckEditBloc>().state;
    final hintText = state.initialDeck?.name ?? '';

    return TextFormField(
      key: const Key('deckEditView_name_textFormField'),
      initialValue: state.name,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: "Deckname",
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9 _]*$')),
      ],
      // return 'Only letters/numbers/spaces, are allowed!';
      onChanged: (value) {
        context.read<DeckEditBloc>().add(DeckEditNameChanged(value));
      },
    );
  }
}

class _ImageUrlField extends StatelessWidget {
  const _ImageUrlField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DeckEditBloc>().state;
    final hintText = state.initialDeck?.image ?? '';

    return TextFormField(
      key: const Key('deckEditView_image_textFormField'),
      initialValue: state.image,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: "Deck imageurl (try to select a square image):",
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
        //!Uri.parse(value).isAbsolute
      ],
      onChanged: (value) {
        context.read<DeckEditBloc>().add(DeckEditImageChanged(value));
      },
    );
  }
}

class _WordsField extends StatelessWidget {
  const _WordsField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DeckEditBloc>().state;
    final hintText = state.initialDeck?.words ?? '';

    return TextFormField(
      key: const Key('deckEditView_words_textFormField'),
      initialValue: state.image,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: "Deck words:",
        hintText: "Enter at least 5 words",
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
        //                              return 'Put at least 5 words seperated with commas.';
        FilteringTextInputFormatter.allow(
            RegExp(r'([a-zA-Z]|,|-|\(|\)|[0-9]|.)*')),
      ],
      onChanged: (value) {
        context.read<DeckEditBloc>().add(DeckEditImageChanged(value));
      },
    );
  }
}
