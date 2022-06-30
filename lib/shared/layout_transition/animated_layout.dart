import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// The bounding box for context in ancestorContext coordinate system, or in the global
// coordinate system when null.
Rect _boundingBoxFor(BuildContext context, [BuildContext? ancestorContext]) {
  final RenderBox box = context.findRenderObject()! as RenderBox;
  assert(box.hasSize);
  return MatrixUtils.transformRect(
    box.getTransformTo(ancestorContext?.findRenderObject()),
    Offset.zero & box.size,
  );
}

/// Specifies which of two children to show. See [AnimatedLayout].
///
/// The child that is shown will fade in, while the other will fade out.
enum LayoutState {
  /// Show the child in close state([AnimatedLayout.fromBuilder]) and hide the second
  /// ([LayoutState.close]]).
  close,

  /// Show the child in open state ([AnimatedLayout.toBuilder]) and hide the first
  /// ([LayoutState.open]).
  open,
}

/// Signature for a function that creates a [Widget] in closed state within an
/// [AnimatedLayout].
typedef ContainerBuilder = Widget Function(
  BuildContext context,
);

class AnimatedLayout extends StatefulWidget {
  const AnimatedLayout({
    Key? key,
    required this.fromBuilder,
    required this.toBuilder,
    required this.duration,
    this.curve = Curves.easeOut,
    this.layoutState = LayoutState.close,
  }) : super(key: key);

  /// The duration of the whole orchestrated animation.
  final Duration duration;

  /// The curve to use in the forward direction.
  final Curve curve;

  /// Called to obtain the child for the container in the initial state.
  final ContainerBuilder fromBuilder;

  /// Called to obtain the child for the container in the final state.
  final ContainerBuilder toBuilder;

  /// The layout that will be shown when the animation has completed.
  final LayoutState layoutState;

  // Returns a map of all of the heroes in `context` indexed by hero tag that
  // should be considered for animation when `navigator` transitions from one
  // PageRoute to another.
  static Map<Object, _LocalHeroState> _allHeroesFor(
    BuildContext context,
  ) {
    final Map<Object, _LocalHeroState> result = <Object, _LocalHeroState>{};

    void inviteHero(StatefulElement hero, Object tag) {
      assert(() {
        if (result.containsKey(tag)) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
                'There are multiple heroes that share the same tag within a subtree.'),
            ErrorDescription(
                'Within each subtree for which heroes are to be animated, '
                'each Hero must have a unique non-null tag.\n'
                'In this case, multiple heroes had the following tag: $tag\n'),
            DiagnosticsProperty<StatefulElement>(
                'Here is the subtree for one of the offending heroes', hero,
                linePrefix: '# ', style: DiagnosticsTreeStyle.dense),
          ]);
        }
        return true;
      }());
      final _LocalHeroState heroState = hero.state as _LocalHeroState;
      result[tag] = heroState;
    }

    void visitor(Element element) {
      final Widget widget = element.widget;
      if (widget is LocalHero) {
        final StatefulElement hero = element as StatefulElement;
        final Object tag = widget.tag;
        inviteHero(hero, tag);
      }
      element.visitChildren(visitor);
    }

    context.visitChildElements(visitor);
    return result;
  }

  @override
  State<AnimatedLayout> createState() => _AnimatedLayoutState();
}

class _AnimatedLayoutState extends State<AnimatedLayout>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fromOpacityAnimation;
  late Animation<double> _toOpacityAnimation;
  // All of the heroes that are currently in the overlay and in motion.
  // Indexed by the hero tag.
  final Map<Object, _LocalHeroFlight> _flights = <Object, _LocalHeroFlight>{};
  late GlobalKey _topKey;
  late GlobalKey _bottomKey;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    if (widget.layoutState == LayoutState.open) {
      _controller.duration = const Duration(milliseconds: 0);
      _controller.forward();
    }
    _fromOpacityAnimation = _initAnimation(widget.curve, inverted: true);
    _toOpacityAnimation = _initAnimation(widget.curve, inverted: false);
    _controller.addStatusListener((AnimationStatus status) {
      setState(() => {});
    });
  }

  Animation<double> _initAnimation(Curve curve, {required bool inverted}) {
    Animation<double> result = _controller.drive(CurveTween(curve: curve));
    if (inverted) result = result.drive(Tween<double>(begin: 1.0, end: 0.0));
    return result;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    _controller.drive(CurveTween(curve: widget.curve));
    if (widget.layoutState != oldWidget.layoutState) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _startTransition();
      });
    }
  }

  final GlobalKey _kFromChildKey = GlobalKey();
  final GlobalKey _kToChildKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool transitioningForwards =
        _controller.status == AnimationStatus.completed ||
            _controller.status == AnimationStatus.forward;

    Widget topChild;
    final Animation<double> topAnimation;
    Widget bottomChild;
    final Animation<double> bottomAnimation;

    if (transitioningForwards) {
      _topKey = _kToChildKey;
      topChild = widget.toBuilder(context);
      topAnimation = _toOpacityAnimation;
      _bottomKey = _kFromChildKey;
      bottomChild = widget.fromBuilder(context);
      bottomAnimation = _fromOpacityAnimation;
    } else {
      _topKey = _kFromChildKey;
      topChild = widget.fromBuilder(context);
      topAnimation = _fromOpacityAnimation;
      _bottomKey = _kToChildKey;
      bottomChild = widget.toBuilder(context);
      bottomAnimation = _toOpacityAnimation;
    }
    bottomChild = FadeTransition(
      opacity: bottomAnimation,
      child: bottomChild,
    );
    topChild = FadeTransition(
      opacity: topAnimation,
      child: topChild,
    );

    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: widget.duration,
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            key: _bottomKey,
            left: 0.0,
            top: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: bottomChild,
          ),
          Positioned(
            key: _topKey,
            left: 0.0,
            top: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: topChild,
          ),
          ..._flights.values.map(
            (flight) => flight.buildOverlay(context),
          ),
        ],
      ),
    );
  }

  void _startTransition() {
    _controller.duration = widget.duration;
    widget.layoutState == LayoutState.open
        ? _openContainer()
        : _closeContainer();
  }

  void _openContainer() {
    _startHeroTransition(_topKey.currentContext!, _bottomKey.currentContext!,
        _controller, LocalHeroFlightDirection.forward);
    _controller.forward();
    //widget.layoutState = LayoutState.open;
  }

  void _closeContainer() {
    _startHeroTransition(_topKey.currentContext!, _bottomKey.currentContext!,
        _controller, LocalHeroFlightDirection.backward);
    _controller.reverse();
    //layoutState = LayoutState.close;
  }

  // Find the matching pairs of heroes in from and to and either start or a new
  // hero flight, or divert an existing one.
  void _startHeroTransition(
    BuildContext from,
    BuildContext to,
    Animation<double> animation,
    LocalHeroFlightDirection flightType,
  ) {
    final Rect toRect = _boundingBoxFor(to);
    // At this point the toHeroes may have been built and laid out for the first time.
    final Map<Object, _LocalHeroState> fromHeroes =
        AnimatedLayout._allHeroesFor(from);
    final Map<Object, _LocalHeroState> toHeroes =
        AnimatedLayout._allHeroesFor(to);

    for (final Object tag in fromHeroes.keys) {
      if (toHeroes[tag] != null) {
        final LocalHeroFlightShuttleBuilder? fromShuttleBuilder =
            fromHeroes[tag]!.widget.flightShuttleBuilder;
        final LocalHeroFlightShuttleBuilder? toShuttleBuilder =
            toHeroes[tag]!.widget.flightShuttleBuilder;

        final _LocalHeroFlightManifest manifest = _LocalHeroFlightManifest(
            animation: CurvedAnimation(
                parent: animation,
                curve: widget.curve,
                reverseCurve: widget.curve.flipped),
            type: flightType,
            toRect: toRect,
            from: from,
            to: to,
            fromHero: fromHeroes[tag]!,
            toHero: toHeroes[tag]!,
            shuttleBuilder: fromShuttleBuilder ??
                toShuttleBuilder ??
                _defaultHeroFlightShuttleBuilder);
        _flights[tag] = _LocalHeroFlight(_handleFlightEnded)..start(manifest);
      }
    }
  }

  void _handleFlightEnded(_LocalHeroFlight flight) {
    _flights.remove(flight.manifest!.tag);
  }

  static final LocalHeroFlightShuttleBuilder _defaultHeroFlightShuttleBuilder =
      (
    Animation<double> animation,
    LocalHeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final LocalHero toHero = toHeroContext.widget as LocalHero;
    return toHero.child;
  };
}

/// Direction of the hero's flight.
enum LocalHeroFlightDirection {
  /// A flight triggered by a openContainer.
  /// The animation goes from 0 to 1.
  forward,

  /// A flight triggered by a closeContainer.
  /// The animation goes from 1 to 0.
  backward,
}

typedef OnFlightEnded = void Function(_LocalHeroFlight flight);

/// A function that lets [Hero]es self supply a [Widget] that is shown during the
/// hero's flight from one route to another instead of default (which is to
/// show the destination route's instance of the Hero).
typedef LocalHeroFlightShuttleBuilder = Widget Function(
  Animation<double> animation,
  LocalHeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
);

class LocalHero extends StatefulWidget {
  final Object tag;
  final Widget child;
  final LocalHeroFlightShuttleBuilder? flightShuttleBuilder;

  const LocalHero(
      {Key? key,
      required this.tag,
      required this.child,
      this.flightShuttleBuilder})
      : super(key: key);

  @override
  State<LocalHero> createState() => _LocalHeroState();
}

class _LocalHeroState extends State<LocalHero> {
  final GlobalKey _key = GlobalKey();
  Size? _placeholderSize;

  @override
  void initState() {
    super.initState();
  }

  void startFlight() {
    assert(mounted);
    final RenderBox box = context.findRenderObject()! as RenderBox;
    assert(box.hasSize);
    setState(() {
      _placeholderSize = box.size;
    });
  }

  void ensurePlaceholderIsHidden() {
    if (mounted) {
      setState(() {
        _placeholderSize = null;
      });
    }
  }

  // When `keepPlaceholder` is true, the placeholder will continue to be shown
  // after the flight ends. Otherwise the child of the Hero will become visible
  // and its TickerMode will be re-enabled.
  void endFlight({bool keepPlaceholder = false}) {
    ensurePlaceholderIsHidden();
  }

  @override
  Widget build(BuildContext context) {
    assert(context.findAncestorWidgetOfExactType<LocalHero>() == null,
        'A LocalHero widget cannot be the descendant of another LocalHero widget.');

    final bool showPlaceholder = _placeholderSize != null;

    if (showPlaceholder) {
      return SizedBox(
        width: _placeholderSize!.width,
        height: _placeholderSize!.height,
      );
    }

    return SizedBox(
      width: _placeholderSize?.width,
      height: _placeholderSize?.height,
      child: Offstage(
        offstage: showPlaceholder,
        child: TickerMode(
          enabled: !showPlaceholder,
          child: KeyedSubtree(key: _key, child: widget.child),
        ),
      ),
    );
  }
}

// Everything known about a hero flight that's to be started or diverted.
class _LocalHeroFlightManifest {
  _LocalHeroFlightManifest({
    required this.animation,
    required this.type,
    required this.toRect,
    required this.from,
    required this.to,
    required this.fromHero,
    required this.toHero,
    required this.shuttleBuilder,
  }) : assert(fromHero.widget.tag == toHero.widget.tag);

  final Animation<double> animation;
  final LocalHeroFlightDirection type;
  final Rect toRect;
  final BuildContext from;
  final BuildContext to;
  final _LocalHeroState fromHero;
  final _LocalHeroState toHero;
  final LocalHeroFlightShuttleBuilder shuttleBuilder;

  Object get tag => fromHero.widget.tag;
}

// Builds the in-flight hero widget.
class _LocalHeroFlight {
  _LocalHeroFlight(this.onFlightEnded) {
    _proxyAnimation.addStatusListener(_performAnimationUpdate);
  }

  final OnFlightEnded onFlightEnded;

  late Tween<Rect?> heroRectTween;
  Widget? shuttle;

  Animation<double> _heroOpacity = kAlwaysCompleteAnimation;
  final ProxyAnimation _proxyAnimation = ProxyAnimation();
  _LocalHeroFlightManifest? manifest;
  bool _aborted = false;

  Tween<Rect?> _doCreateRectTween(Rect? begin, Rect? end) {
    return RectTween(begin: begin, end: end);
  }

  static final Animatable<double> _reverseTween =
      Tween<double>(begin: 1.0, end: 0.0);

  // The OverlayEntry WidgetBuilder callback for the hero's overlay.
  Widget buildOverlay(BuildContext context) {
    assert(manifest != null);

    shuttle ??= manifest!.shuttleBuilder(
      manifest!.animation,
      manifest!.type,
      manifest!.fromHero.context,
      manifest!.toHero.context,
    );
    assert(shuttle != null);

    return AnimatedBuilder(
      animation: _proxyAnimation,
      child: shuttle,
      builder: (BuildContext context, Widget? child) {
        final RenderBox? toHeroBox = manifest!.toHero.mounted
            ? manifest!.toHero.context.findRenderObject() as RenderBox?
            : null;
        if (_aborted || toHeroBox == null || !toHeroBox.attached) {
          // The toHero no longer exists or it's no longer the flight's destination.
          // Continue flying while fading out.
          if (_heroOpacity.isCompleted) {
            _heroOpacity = _proxyAnimation.drive(
              _reverseTween.chain(
                  CurveTween(curve: Interval(_proxyAnimation.value, 1.0))),
            );
          }
        } else if (toHeroBox.hasSize) {
          // The toHero has been laid out. If it's no longer where the hero animation is
          // supposed to end up then recreate the heroRect tween.
          final RenderBox? finalConatinerBox =
              manifest!.to.findRenderObject() as RenderBox?;

          final Offset toHeroOrigin =
              toHeroBox.localToGlobal(Offset.zero, ancestor: finalConatinerBox);

          if (toHeroOrigin != heroRectTween.end!.topLeft) {
            final Rect heroRectEnd = toHeroOrigin & heroRectTween.end!.size;
            heroRectTween =
                _doCreateRectTween(heroRectTween.begin, heroRectEnd);
          }
        }

        final Rect rect = heroRectTween.evaluate(_proxyAnimation)!;
        final Size size = (manifest!.to.findRenderObject() as RenderBox).size;
        //print(rect);
        final RelativeRect offsets = RelativeRect.fromSize(rect, size);
        return Positioned(
          top: max(offsets.top, 0),
          right: max(offsets.right, 0),
          bottom: max(offsets.bottom, 0),
          left: max(offsets.left, 0),
          child: IgnorePointer(
            child: RepaintBoundary(
              child: Opacity(
                opacity: _heroOpacity.value,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  void _performAnimationUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      _proxyAnimation.parent = null;

      // We want to keep the hero underneath the current page hidden. If
      // [AnimationStatus.completed], toHero will be the one on top and we keep
      // fromHero hidden. If [AnimationStatus.dismissed], the animation is
      // triggered but canceled before it finishes. In this case, we keep toHero
      // hidden instead.
      manifest!.fromHero
          .endFlight(keepPlaceholder: status == AnimationStatus.completed);
      manifest!.toHero
          .endFlight(keepPlaceholder: status == AnimationStatus.dismissed);
      onFlightEnded(this);
    }
  }

  // The simple case: we're either starting a forward or a backward animation.
  void start(_LocalHeroFlightManifest initialManifest) {
    assert(!_aborted);

    manifest = initialManifest;

    if (manifest!.type == LocalHeroFlightDirection.backward) {
      _proxyAnimation.parent = ReverseAnimation(manifest!.animation);
    } else {
      _proxyAnimation.parent = manifest!.animation;
    }

    manifest!.fromHero.startFlight();
    manifest!.toHero.startFlight();

    heroRectTween = _doCreateRectTween(
      _boundingBoxFor(manifest!.fromHero.context, manifest!.from),
      _boundingBoxFor(manifest!.toHero.context, manifest!.to),
    );
  }

  void abort() {
    _aborted = true;
  }
}
