import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_style_ui/core/widgets/adaptive_context.dart';

/// Page skeleton: `Scaffold` + `AppBar` or `CupertinoPageScaffold` +
/// `CupertinoNavigationBar`, depending on the active style.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({required this.title, required this.body, super.key});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    if (context.isCupertino) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(middle: Text(title)),
        // Material widgets (Card, InkWell) inside need a Material ancestor.
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(child: body),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(child: body),
    );
  }
}
