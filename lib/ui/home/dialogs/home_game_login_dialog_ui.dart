import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:starcitizen_doctor/widgets/widgets.dart';

import 'home_game_login_dialog_ui_model.dart';

class HomeGameLoginDialogUI extends HookConsumerWidget {
  final BuildContext launchContext;

  const HomeGameLoginDialogUI(this.launchContext, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(homeGameLoginUIModelProvider);
    useEffect(() {
      ref
          .read(homeGameLoginUIModelProvider.notifier)
          .launchWebLogin(launchContext);
      return null;
    }, []);
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .56,
      ),
      title: (loginState.loginStatus == 2)
          ? null
          : Text(S.current.home_action_one_click_launch),
      content: AnimatedSize(
        duration: const Duration(milliseconds: 230),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(),
              if (loginState.loginStatus == 0) ...[
                Center(
                  child: Column(
                    children: [
                      Text(S.current.home_title_logging_in),
                      const SizedBox(height: 12),
                      const ProgressRing(),
                    ],
                  ),
                ),
              ] else if (loginState.loginStatus == 2 ||
                  loginState.loginStatus == 3) ...[
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        S.current.home_login_title_welcome_back,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 24),
                      if (loginState.avatarUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: CacheNetImage(
                            url: loginState.avatarUrl!,
                            width: 128,
                            height: 128,
                            fit: BoxFit.fill,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(
                        loginState.nickname ?? "",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (loginState.libraryData?.games != null) ...[
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: FluentTheme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final game in loginState.libraryData!.games!)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FluentIcons.skype_circle_check,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 6),
                                      Text("${game.name}"),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(height: 24)
                      ],
                      const SizedBox(height: 12),
                      Text(S.current.home_login_title_launching_game),
                      const SizedBox(height: 12),
                      const ProgressRing(),
                      const SizedBox(height: 12),
                    ],
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
