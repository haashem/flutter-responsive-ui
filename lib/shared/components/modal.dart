import 'package:flutter/material.dart';
import '../layout_transition/animated_layout.dart';

class Modal extends StatelessWidget {
  final Widget child;
  final VoidCallback onCloseButtonPressed;
  final IconData icon;
  final String title;

  const Modal(
      {super.key,
      required this.child,
      required this.icon,
      required this.title,
      required this.onCloseButtonPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedLayout(
      duration: const Duration(milliseconds: 250),
      layoutState: LayoutState.close,
      fromBuilder: (context) => _NonMobileModal(
          icon: icon,
          title: title,
          onCloseButtonPressed: onCloseButtonPressed,
          child: child),
      toBuilder: (context) => _MobileModal(
          icon: icon,
          title: title,
          onCloseButtonPressed: onCloseButtonPressed,
          child: child),
    );
  }

}

class _MobileModal extends StatelessWidget {
  const _MobileModal({
    Key? key,
    required this.icon,
    required this.title,
    required this.child,
    required this.onCloseButtonPressed,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Widget child;
  final VoidCallback onCloseButtonPressed;

  @override
  Widget build(BuildContext context) {
    return LocalHero(
      tag: 1,
      child: Material(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 65,
                  ),
                  Icon(
                    icon,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: child,
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: 8,
              end: 16,
              child: Stack(
                children: [
                  const SizedBox(
                    height: 55,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: IconButton(
                        onPressed: onCloseButtonPressed,
                        icon: const Icon(Icons.close)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NonMobileModal extends StatelessWidget {
  const _NonMobileModal({
    Key? key,
    required this.icon,
    required this.title,
    required this.child,
    required this.onCloseButtonPressed,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Widget child;
  final VoidCallback onCloseButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LocalHero(
        tag: 1,
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 690, maxHeight: 750),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 30,
                      color: Colors.black.withOpacity(0.07),
                    )
                  ]),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 65,
                        ),
                        Icon(
                          icon,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 76),
                          child: child,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  PositionedDirectional(
                    start: 8,
                    end: 16,
                    child: Stack(
                      children: [
                        const SizedBox(
                          height: 55,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: IconButton(
                              onPressed: onCloseButtonPressed,
                              icon: const Icon(Icons.close)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
