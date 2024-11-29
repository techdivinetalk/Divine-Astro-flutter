library flutter_carousel_widget;

import 'dart:async';

import 'package:carousel_slider/utils.dart';
import 'package:divine_astrologer/tarotCard/src/typedefs/widget_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'enums/carousel_page_changed_reason.dart';
import 'enums/center_page_enlarge_strategy.dart';
import 'helpers/flutter_carousel_controller.dart';
import 'helpers/flutter_carousel_options.dart';
import 'helpers/flutter_carousel_state.dart';

class FlutterCarousel extends StatefulWidget {
  /// The default constructor
  const FlutterCarousel({
    required this.items,
    required this.options,
    Key? key,
  })  : itemBuilder = null,
        itemCount = items != null ? items.length : 0,
        assert(items != null),
        super(key: key);

  /// The on demand item builder constructor
  const FlutterCarousel.builder({
    required this.itemCount,
    required this.itemBuilder,
    required this.options,
    Key? key,
  })  : items = null,
        assert(itemCount != null),
        assert(itemBuilder != null),
        super(key: key);

  /// The widget item builder that will be used to build item on demand
  /// The third argument is the PageView's real index, can be used to cooperate
  /// with Hero.
  final ExtendedWidgetBuilder? itemBuilder;

  /// The count of items to be shown in the carousel
  final int? itemCount;

  /// The widgets to be shown in the carousel of default constructor
  final List<Widget>? items;

  /// [CarouselOptions] to create a [FlutterCarouselState] with
  final CarouselOptions options;

  @override
  FlutterCarouselState createState() => FlutterCarouselState();
}

class FlutterCarouselState extends State<FlutterCarousel>
    with TickerProviderStateMixin {
  /// mode is related to why the page is being changed
  CarouselPageChangedReason changeReasonMode =
      CarouselPageChangedReason.controller;

  CarouselState? _carouselState;
  int _currentPage = 0;
  PageController? _pageController;
  double _pageDelta = 0.0;
  Timer? _timer;

  void _changeIndexPageDelta() {
    var realIndex = getRealIndex(
      _carouselState!.pageController!.page!.floor(),
      _carouselState!.realPage,
      widget.itemCount ?? widget.items?.length,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentPage = realIndex;
          _pageDelta = _pageController!.page! - _pageController!.page!.floor();
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant FlutterCarousel oldWidget) {
    _carouselState!.options = options;
    _carouselState!.itemCount = widget.itemCount;

    /// [_pageController] needs to be re-initialized to respond
    /// to state changes
    _pageController = PageController(
      viewportFraction: options.viewportFraction,
      keepPage: options.keepPage,
      initialPage: _carouselState!.realPage,
    );

    _carouselState!.pageController = _pageController;

    /// handle autoplay when state changes
    _handleAutoPlay();

    _pageController!.addListener(_changeIndexPageDelta);

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController?.removeListener(_changeIndexPageDelta);
    _pageController?.dispose();
    _clearTimer();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _carouselState = CarouselState(
      options,
      _clearTimer,
      _resumeTimer,
      changeMode,
    );

    _carouselState!.itemCount = widget.itemCount;
    carouselController.state = _carouselState;
    _carouselState!.initialPage = widget.options.initialPage;
    _carouselState!.realPage = options.enableInfiniteScroll
        ? _carouselState!.realPage + _carouselState!.initialPage
        : _carouselState!.initialPage;

    _handleAutoPlay();

    _pageController = PageController(
      viewportFraction: options.viewportFraction,
      keepPage: options.keepPage,
      initialPage: _carouselState!.realPage,
    );

    _carouselState!.pageController = _pageController;

    _pageController!.addListener(_changeIndexPageDelta);
  }

  CarouselControllerImpl get carouselController =>
      widget.options.controller != null
          ? widget.options.controller as CarouselControllerImpl
          : CarouselController() as CarouselControllerImpl;

  CarouselOptions get options => widget.options;

  /// Timer
  Timer? _getTimer() {
    if (!widget.options.autoPlay) {
      return null;
    }

    return Timer.periodic(widget.options.autoPlayInterval, (_) {
      final route = ModalRoute.of(context);
      if (route?.isCurrent == false) {
        return;
      }

      var previousReason = changeReasonMode;
      changeMode(CarouselPageChangedReason.timed);

      var itemCount = widget.itemCount ?? widget.items!.length;
      var nextPage = _carouselState!.pageController!.page!.round() + 1;

      if (nextPage >= itemCount &&
          widget.options.enableInfiniteScroll == false) {
        if (widget.options.pauseAutoPlayInFiniteScroll) {
          _clearTimer();
          return;
        }
        nextPage = 0;
      }

      _carouselState!.pageController!
          .animateToPage(
            nextPage,
            duration: widget.options.autoPlayAnimationDuration,
            curve: widget.options.autoPlayCurve,
          )
          .then((_) => changeMode(previousReason));
    });
  }

  void changeMode(CarouselPageChangedReason _mode) {
    changeReasonMode = _mode;
  }

  /// Clear Timer
  void _clearTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// Resume Timer
  void _resumeTimer() {
    _timer ??= _getTimer();
  }

  /// Autoplay
  void _handleAutoPlay() {
    var autoPlayEnabled = widget.options.autoPlay;

    if (autoPlayEnabled && _timer != null) return;

    _clearTimer();
    if (autoPlayEnabled) {
      _resumeTimer();
    }
  }

  /// onStart
  void _onStart() {
    changeMode(CarouselPageChangedReason.manual);
  }

  /// onPanDown
  void _onPanDown() {
    if (widget.options.pauseAutoPlayOnTouch) {
      _clearTimer();
    }

    changeMode(CarouselPageChangedReason.manual);
  }

  /// onPanEnd
  void _onPanUp() {
    if (widget.options.pauseAutoPlayOnTouch) {
      _resumeTimer();
    }
  }

  Widget _getGestureWrapper({required Widget child}) {
    Widget wrapper;
    if (widget.options.height != null) {
      wrapper = SizedBox(
        height: widget.options.height,
        child: child,
      );
    } else {
      wrapper = AspectRatio(
        aspectRatio: widget.options.aspectRatio ?? 1 / 1,
        child: child,
      );
    }

    return RawGestureDetector(
      gestures: {
        _MultipleGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<_MultipleGestureRecognizer>(
                _MultipleGestureRecognizer.new,
                (_MultipleGestureRecognizer instance) {
          instance.onStart = (_) {
            _onStart();
          };
          instance.onDown = (_) {
            _onPanDown();
          };
          instance.onEnd = (_) {
            _onPanUp();
          };
          instance.onCancel = _onPanUp;
        }),
      },
      child: NotificationListener(
        onNotification: (dynamic notification) {
          if (widget.options.onScrolled != null &&
              notification is ScrollUpdateNotification) {
            widget.options.onScrolled!(_carouselState!.pageController!.page);
          }
          return false;
        },
        child: wrapper,
      ),
    );
  }

  /// The method that build center wrapper
  Widget _getCenterWrapper(Widget child) {
    if (widget.options.disableCenter) {
      return child;
    }
    return Center(child: child);
  }

  /// The method that build enlarge wrapper
  Widget _getEnlargeWrapper(Widget? child,
      {double? width, double? height, double? scale}) {
    /// If [enlargeStrategy] is [CenterPageEnlargeStrategy.height]
    if (widget.options.enlargeStrategy == CenterPageEnlargeStrategy.height) {
      return SizedBox(
        width: width,
        height: height,
        child: child,
      );
    }
    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }

  /// The method that builds the carousel
  Widget _buildCarouselWidget(BuildContext context) {
    return PageView.builder(
      key: widget.options.pageViewKey,
      scrollBehavior: widget.options.scrollBehavior ??
          ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
            overscroll: false,
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
      clipBehavior: widget.options.clipBehavior,
      physics: widget.options.physics,
      scrollDirection: widget.options.scrollDirection,
      pageSnapping: widget.options.pageSnapping,
      controller: _carouselState!.pageController,
      reverse: widget.options.reverse,
      dragStartBehavior: widget.options.dragStartBehavior,
      allowImplicitScrolling: widget.options.allowImplicitScrolling,
      restorationId: widget.options.restorationId,
      padEnds: widget.options.padEnds,
      onPageChanged: (int index) {
        var currentPage = getRealIndex(
          index + _carouselState!.initialPage,
          _carouselState!.realPage,
          widget.itemCount,
        );

        if (widget.options.onPageChanged != null) {
          widget.options.onPageChanged!(
            currentPage,
            changeReasonMode,
          );
        }
      },
      itemCount: widget.options.enableInfiniteScroll ? null : widget.itemCount,
      itemBuilder: (BuildContext context, int idx) {
        final index = getRealIndex(
          idx + _carouselState!.initialPage,
          _carouselState!.realPage,
          widget.itemCount,
        );

        return AnimatedBuilder(
          animation: _carouselState!.pageController!,
          child: (widget.items != null)
              ? (widget.items!.isNotEmpty
                  ? widget.items![index]
                  : const SizedBox())
              : widget.itemBuilder!(context, index, idx),
          builder: (BuildContext context, Widget? child) {
            var distortionValue = 1.0;

            /// if `enlargeCenterPage` is true, we must calculate the carousel
            /// item's height to display the visual effect
            if (widget.options.enlargeCenterPage != null &&
                widget.options.enlargeCenterPage == true) {
              /// pageController.page can only be accessed after the first
              /// build, so in the first build we calculate the item
              /// offset manually
              var itemOffset = 0.0;
              var position = _carouselState?.pageController?.position;
              if (position != null &&
                  position.hasPixels &&
                  position.hasContentDimensions) {
                var page = _carouselState?.pageController?.page;
                if (page != null) {
                  itemOffset = page - idx;
                }
              } else {
                var storageContext = _carouselState!
                    .pageController!.position.context.storageContext;
                final previousSavedPosition = PageStorage.of(storageContext)
                    .readState(storageContext) as double?;
                if (previousSavedPosition != null) {
                  itemOffset = previousSavedPosition - idx.toDouble();
                } else {
                  itemOffset =
                      _carouselState!.realPage.toDouble() - idx.toDouble();
                }
              }

              /// Calculate [distortionRatio]
              final distortionRatio =
                  1 - (itemOffset.abs() * 0.25).clamp(0.0, 1.0);
              distortionValue = Curves.easeOut.transform(distortionRatio);
            }

            /// Calculate [height]
            final height = widget.options.height ??
                MediaQuery.of(context).size.width *
                    (1 / (widget.options.aspectRatio ?? 1 / 1));

            /// If [scrollDirection] option is [Axis.horizontal]
            if (widget.options.scrollDirection == Axis.horizontal) {
              return _getCenterWrapper(
                _getEnlargeWrapper(
                  child,
                  height: distortionValue * height,
                  scale: distortionValue,
                ),
              );
            } else {
              return _getCenterWrapper(
                _getEnlargeWrapper(
                  child,
                  width: distortionValue * MediaQuery.of(context).size.width,
                  scale: distortionValue,
                ),
              );
            }
          },
        );
      },
    );
  }

  /// The method to build the slide indicator
  // Widget _buildSlideIndicator() {
  //   return widget.options.slideIndicator!.build(
  //     _currentPage,
  //     _pageDelta,
  //     widget.itemCount!,
  //   );
  // }

  /// The method to build the carousel widget
  Widget _buildWidget(BuildContext context) {
    if (widget.options.showIndicator && widget.itemCount! > 1) {
      /// If [floatingIndicator] option is [true]
      if (widget.options.floatingIndicator) {
        return _getGestureWrapper(
          child: Stack(
            children: [
              _buildCarouselWidget(context),
            ],
          ),
        );
      }

      /// If [floatingIndicator] option is [false]
      return _getGestureWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: _buildCarouselWidget(context),
            ),
            SizedBox(height: widget.options.indicatorMargin),
          ],
        ),
      );
    }

    return _getGestureWrapper(child: _buildCarouselWidget(context));
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }
}

class _MultipleGestureRecognizer extends PanGestureRecognizer {}
