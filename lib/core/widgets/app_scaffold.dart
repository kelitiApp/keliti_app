import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Common page scaffold: safe area + horizontal page padding + optional
/// scrolling + a pinned bottom action button. Used by the majority of
/// screens instead of re-declaring Scaffold/SafeArea/Padding everywhere.
///
/// [bottomBar] is layered as a positioned overlay rather than passed to
/// `Scaffold.bottomNavigationBar` — when a page built with this scaffold is
/// itself nested inside another Scaffold (e.g. a bottom-nav tab shell using
/// `IndexedStack`), a second nested `bottomNavigationBar` slot can end up
/// with degenerate (zero) height, silently hiding the whole body. The
/// overlay approach works identically whether the page is pushed standalone
/// or nested in a shell.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.scrollable = true,
    this.bottomBar,
    this.backgroundColor,
    this.padHorizontal = true,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget body;
  final bool scrollable;
  final Widget? bottomBar;
  final Color? backgroundColor;
  final bool padHorizontal;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final content = padHorizontal
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: body,
          )
        : body;

    final hasBottomBar = bottomBar != null;

    final bodyContent = SafeArea(
      bottom: !hasBottomBar,
      child: scrollable
          ? SingleChildScrollView(
              padding: EdgeInsets.only(top: AppSpacing.md, bottom: hasBottomBar ? 100 : AppSpacing.xl),
              child: content,
            )
          : content,
    );

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: hasBottomBar
          ? Stack(
              children: [
                Positioned.fill(child: bodyContent),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    minimum: const EdgeInsets.fromLTRB(
                      AppSpacing.pageHorizontal,
                      AppSpacing.sm,
                      AppSpacing.pageHorizontal,
                      AppSpacing.md,
                    ),
                    child: bottomBar!,
                  ),
                ),
              ],
            )
          : bodyContent,
    );
  }
}
