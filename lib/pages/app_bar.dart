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
  final int timelineFrames = 48;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // called when animation status changed. see AnimationStatus.
    animationController.addStatusListener((status) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        // 1
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
          // 2
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
                parent: animation, curve: Interval(0, 24 / timelineFrames)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sections.entries.mapIndexed(
                    (index, e) {
                      // 3
                      final itemAnimation = CurvedAnimation(
                        parent: animationController,
                        curve: Interval(
                            10 / timelineFrames +
                                (5 - index) * 1 / 5 * 10 / timelineFrames,
                            1,
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
        // 4
        if (animationController.isAnimating || animationController.isCompleted)
          // 5
          Expanded(
            child: GestureDetector(
              onTap: () {
                animationController.reverse();
              },
              // 6
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
