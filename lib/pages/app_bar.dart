import 'package:appleid_dashboard/shared/responsive.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../menu/view_model.dart';

class AppBar extends StatefulWidget {
  final ValueChanged<int> onItemTapped;
  const AppBar({super.key, required this.onItemTapped});

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    animationController.addStatusListener((status) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //const curve = Curves.linear;
    final animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    // hide menu when layout changed to non-mobile
    if (Responsive.isMobile(context) == false) {
      animationController.reverse(from: 0);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 55,
            child: Row(
              children: [
                Text(
                  'Apple ID',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                if (Responsive.isMobile(context))
                  IconButton(
                      onPressed: () {
                        if (animationController.isDismissed) {
                          animationController.forward();
                        } else if (animationController.isCompleted) {
                          animationController.reverse();
                        } else if (animationController.isAnimating &&
                            animationController.status ==
                                AnimationStatus.forward) {
                          animationController.reverse();
                        } else {
                          animationController.forward();
                        }
                      },
                      icon: const Icon(Icons.expand_more)),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)))),
                    onPressed: () {},
                    child: const Text('Sign Out'))
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        Material(
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
                parent: animation, curve: const Interval(0, 24 / 48)),
            child: SlideTransition(
              position:
                  Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
                      .animate(CurvedAnimation(
                          parent: animation,
                          curve: const Interval(0, 24 / 48))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: sections.entries.mapIndexed(
                      (index, e) {
                        final itemAnimation = CurvedAnimation(
                          parent: animationController,
                          curve: Interval(
                              10 / 48 + (5 - index) * 1 / 5 * 10 / 48, 1,
                              curve: Curves.easeOutCubic),
                        );
                        return SlideTransition(
                          position: Tween(
                                  begin: Offset(0, -(6 - index) * 3 / 2),
                                  end: const Offset(0, 0))
                              .animate(
                            itemAnimation,
                          ),
                          child: FadeTransition(
                            opacity: CurvedAnimation(
                              parent: animationController,
                              curve: Interval(
                                  ((sections.length - (index + 1)) / 6), 1,
                                  curve: Curves.easeInQuad),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(e.value),
                                  onTap: () {
                                    animationController.reverse();
                                    widget.onItemTapped(index);
                                  },
                                ),
                                if (index != sections.length - 1)
                                  const Divider(
                                    height: 1,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList()),
              ),
            ),
          ),
        ),
        if (animationController.isAnimating || animationController.isCompleted)
          Expanded(
            child: GestureDetector(
              onTap: () {
                animationController.reverse();
              },
              child: DecoratedBoxTransition(
                  decoration: DecorationTween(
                          begin: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          end: const BoxDecoration(color: Colors.black38))
                      .animate(animation),
                  child: Container()),
            ),
          )
      ],
    );
  }
}
