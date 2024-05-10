import 'package:flutter/material.dart';
import 'package:firebase_authentication_project/src/constants/design/paddings.dart';
import 'package:firebase_authentication_project/src/services/theme/app_theme.dart';
import 'package:firebase_authentication_project/src/constants/design/border_radius.dart';

class ResponsiveTwoSidedCard extends StatelessWidget {
  const ResponsiveTwoSidedCard({
    super.key,
    required this.leftSideWidget,
    required this.rightSideWidget,
  });

  final Widget leftSideWidget;
  final Widget rightSideWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontal24 + vertical24 + horizontal24,
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: context.color.mainBackground,
        shape: const RoundedRectangleBorder(borderRadius: br12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1050,
          ),
          child: IntrinsicHeight(
            child: IntrinsicWidth(
              child: Row(
                children: [
                  Expanded(
                    child: leftSideWidget,
                  ),
                  Expanded(
                    child: rightSideWidget,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
