import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

class ExampleMenu extends StatelessWidget {
  const ExampleMenu({
    super.key,
    required this.builder,
  });

  final PullDownMenuButtonBuilder builder;

  @override
  Widget build(BuildContext context) => PullDownButton(
        itemBuilder: (context) => [
          PullDownMenuHeader(
            leading: ColoredBox(
              color: CupertinoColors.systemBlue.resolveFrom(context),
            ),
            title: 'Profile',
            subtitle: 'Tap to open',
            onTap: () {},
            icon: CupertinoIcons.profile_circled,
          ),
          const PullDownMenuDivider.large(),
          PullDownMenuActionsRow.medium(
            items: [
              PullDownMenuItem(
                onTap: () {},
                title: 'Reply',
                icon: CupertinoIcons.arrowshape_turn_up_left,
              ),
              PullDownMenuItem(
                onTap: () {},
                title: 'Copy',
                icon: CupertinoIcons.doc_on_doc,
              ),
              PullDownMenuItem(
                onTap: () {},
                title: 'Edit',
                icon: CupertinoIcons.pencil,
              ),
            ],
          ),
          const PullDownMenuDivider.large(),
          PullDownMenuItem(
            onTap: () {},
            title: 'Pin',
            icon: CupertinoIcons.pin,
          ),
          PullDownMenuItem(
            title: 'Forward',
            subtitle: 'Share in different channel',
            onTap: () {},
            icon: CupertinoIcons.arrowshape_turn_up_right,
          ),
          PullDownMenuItem(
            onTap: () {},
            title: 'Delete',
            isDestructive: true,
            icon: CupertinoIcons.delete,
          ),
          const PullDownMenuDivider.large(),
          PullDownMenuItem(
            title: 'Select',
            onTap: () {},
            icon: CupertinoIcons.checkmark_circle,
          ),
        ],
        animationBuilder: null,
        position: PullDownMenuPosition.automatic,
        buttonBuilder: builder,
      );
}