import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_product_carousel/src/custom_widgets.dart';
import 'package:flutter_product_carousel/src/product_360_view.dart';
import 'package:flutter_product_carousel/src/product_carousel_controller.dart';
import 'package:flutter_product_carousel/src/product_carousel_options.dart';
import 'package:flutter_product_carousel/src/utils.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    super.key,
    required this.imagesList,
    this.multiImagesList,
    required this.productCarouselOptions,
    required this.onTap,
    this.boxFit,
    ProductCarouselController? productCarouselController,
  });

  final List<String> imagesList;

  final List<ImageProvider>? multiImagesList;

  final ProductCarouselOptions productCarouselOptions;
  final Function(int index) onTap;
  final BoxFit? boxFit;

  @override
  State<Carousel> createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  /// _timer to set the timer for the auto play of the carousel images
  Timer? _timer;

  /// _current to set the current index of the carousel images
  int _current = 0;

  /// _isUserTouching to set the user touching state of the carousel images to enable or disable the auto play

  bool _isUserTouching = false;

  /// scrollOffset to set the scroll offset of the carousel images to get the current index of the carousel images
  int scrollOffset = 10000;

  /// _productCarouselController to set the product carousel controller for the carousel images to handle the page controller,
  /// and to handle the next and previous page of the carousel images

  ProductCarouselControllerImpl? _productCarouselController;

  PageController? get pageController =>
      _productCarouselController?.pageController;

  /// view360DegreeView to view the image in 360° view
  bool view360DegreeView = false;

  @override
  void didUpdateWidget(covariant Carousel oldWidget) {
    /// Reset the current index when the images list changes
    if (oldWidget.imagesList != widget.imagesList) {
      setState(() {
        _current = 0;
      });
    }
    widget.multiImagesList?.isNotEmpty == true ? cancelTimer() : autoPlay();

    /// Reset the page controller when the product carousel options change
    _productCarouselController?.pageController = PageController(
      viewportFraction: widget.productCarouselOptions.viewportFraction,
      initialPage: widget.productCarouselOptions.initialPage,
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  initState() {
    /// Set the initial page and viewport fraction when the widget is initialized
    widget.multiImagesList?.isNotEmpty == true ? cancelTimer() : autoPlay();
    view360DegreeView = false;
    _productCarouselController =
        widget.productCarouselOptions is ProductCarouselControllerImpl
            ? widget.productCarouselOptions as ProductCarouselControllerImpl
            : ProductCarouselController() as ProductCarouselControllerImpl;
    _productCarouselController?.pageController = PageController(
      viewportFraction: widget.productCarouselOptions.viewportFraction,
      initialPage: widget.productCarouselOptions.initialPage,
    );

    super.initState();
  }

  @override
  void dispose() {
    cancelTimer();
    _productCarouselController?.pageController?.dispose();
    super.dispose();
  }

  /// tickTimer to set the timer for the auto play of the carousel images to move to the next image after the time interval
  /// if the auto play is enabled
  tickTimer() {
    _timer == null
        ? _timer = Timer.periodic(
            Duration(
              seconds: widget.productCarouselOptions.autoPlayDuration.inSeconds,
            ),
            (Timer timer) {
              if (!mounted) return;
              int newIndex = 0;
              if (_current < widget.imagesList.length - 1) {
                newIndex = (_productCarouselController?.pageController?.page
                            ?.round() ??
                        0) +
                    1;
              } else {
                newIndex = 0;
              }
              _productCarouselController?.pageController?.animateToPage(
                newIndex,
                duration: widget.productCarouselOptions.autoPlayTimeInterval,
                curve: Curves.fastOutSlowIn,
              );
            },
          )
        : null;
  }

  /// cancelTimer to cancel the timer for the auto play of the carousel images
  /// if the auto play is disabled or the user is touching the carousel images to disable the auto play and enable it again
  /// when the user is not touching the carousel images it will enable the auto play
  cancelTimer() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
    }
    _timer = null;
  }

  /// auto play is disabled by default, if you want to enable it, set autoPlay to true,
  /// and set the autoPlayTimeInterval to the duration you want to use for the auto play
  autoPlay() {
    if (widget.productCarouselOptions.autoPlay) {
      tickTimer();
    } else {
      cancelTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (view360DegreeView == true) {
      return ProductImage360View(
        key: UniqueKey(),
        imageList: widget.multiImagesList ?? [],
        frameChangeDuration:
            widget.productCarouselOptions.frameChangeDuration ??
                const Duration(milliseconds: 90),
        onCloseTap: (bool value) {
          setState(() {
            view360DegreeView = value;
          });
        },
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.imagesList.isEmpty
              ? _buildCarouselEmptyState(context)
              : GestureDetector(
                  onTap: () {
                    if (_isUserTouching) {
                      autoPlay();
                    } else {
                      _timer?.cancel();
                    }
                    _isUserTouching = !_isUserTouching;
                  },
                  child: getWrapper(
                    _buildPageView(context),
                  ),
                ),
          if (widget.imagesList.length > 1)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
          if (widget.imagesList.length > 1) _buildNavigatorsWithIcons(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
        ],
      );
    }
  }

  Padding _buildCarouselEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: extendedImage(
          url:
              'https://assets-global.website-files.com/60d251a34163cf29e1220806/63742e4e397f173624ab462e_355-3557482_flutter-logo-png-transparent-png.png',
          width: MediaQuery.of(context).size.width,
          fit: widget.boxFit ?? BoxFit.fill,
        ),
      ),
    );
  }

  PageView _buildPageView(BuildContext context) {
    return PageView.builder(
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        overscroll: false,
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      restorationId: 'carousel',
      allowImplicitScrolling: true,
      reverse: widget.productCarouselOptions.isReverse,
      scrollDirection: widget.productCarouselOptions.scrollDirection,
      pageSnapping: widget.productCarouselOptions.pageSnapping,
      physics: widget.productCarouselOptions.physics ??
          const AlwaysScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        int newIndex = getCurrentIndex(
            index + widget.productCarouselOptions.initialPage,
            scrollOffset,
            widget.imagesList.length);
        if (widget.productCarouselOptions.onPageChanged != null) {
          widget.productCarouselOptions.onPageChanged!(index);
        }
        if (widget.productCarouselOptions.enabledInfiniteScroll) {
          if ((pageController?.position.pixels ?? 0.0) >=
              (pageController?.position.maxScrollExtent ?? 0.0)) {
            pageController?.jumpToPage(0);
            setState(() {});
          }
        }
        setState(() {
          _current = newIndex;
        });
      },
      itemCount: widget.multiImagesList?.isNotEmpty == true
          ? widget.imagesList.length + 1
          : widget.productCarouselOptions.enabledInfiniteScroll
              ? null
              : widget.imagesList.length,
      itemBuilder: (context, index) {
        if (widget.multiImagesList?.isNotEmpty == true && _current == 0) {
          return Stack(
            children: [
              Image(image: widget.multiImagesList![_current]),
              Positioned(
                bottom: 10.0,
                right: 10.0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.008,
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.red.shade800,
                        width: 2.0,
                      ),
                      shape: BoxShape.rectangle),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        view360DegreeView = true;
                      });
                    },
                    child: Text(
                      '360° View',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return GestureDetector(
          key: ValueKey<int>(_current),
          onTap: () {
            widget.onTap(widget.imagesList.map((e) {
              return widget.imagesList.indexOf(e);
            }).toList()[_current]);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: extendedImage(
                url: widget.imagesList[_current],
                width: MediaQuery.of(context).size.width,
                fit: widget.boxFit ?? BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }

  Padding _buildNavigatorsWithIcons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.016,
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Row(
        mainAxisAlignment: widget.productCarouselOptions.showNavigationIcons
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.productCarouselOptions.showNavigationIcons ||
              widget.productCarouselOptions.backwardIcon != null)
            InkWell(
              onTap: () {
                _productCarouselController?.previousPage();
              },
              child: Icon(
                widget.productCarouselOptions.backwardIcon ??
                    (defaultTargetPlatform == TargetPlatform.iOS
                        ? Icons.arrow_back_ios
                        : Icons.arrow_back),
                size: MediaQuery.of(context).size.width * 0.06,
                color: _current <= 0
                    ? Colors.grey.shade800
                    : widget.productCarouselOptions.indicatorsColor ??
                        Colors.red.shade500,
              ),
            ),
          Expanded(child: _buildIndicatorsWrapper()),
          if (widget.productCarouselOptions.showNavigationIcons ||
              widget.productCarouselOptions.forwardIcon != null)
            InkWell(
              onTap: () {
                if (_productCarouselController?.pageController?.hasClients ==
                    true) {
                  _productCarouselController?.nextPage();
                }
              },
              child: Icon(
                widget.productCarouselOptions.forwardIcon ??
                    (defaultTargetPlatform == TargetPlatform.iOS
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_forward),
                size: MediaQuery.of(context).size.width * 0.06,
                color: _current >= widget.imagesList.length - 1
                    ? Colors.grey.shade300
                    : widget.productCarouselOptions.indicatorsColor ??
                        Colors.red.shade500,
              ),
            ),
        ],
      ),
    );
  }

  Wrap _buildIndicatorsWrapper() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: widget.imagesList.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () {
            _productCarouselController?.pageController?.animateToPage(
              entry.key,
              duration: const Duration(microseconds: 800),
              curve: Curves.fastOutSlowIn,
            );
          },
          child: Container(
            width: _current == entry.key
                ? MediaQuery.of(context).size.width * 0.04
                : MediaQuery.of(context).size.width * 0.02,
            height: MediaQuery.of(context).size.height * 0.01,
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.005,
              horizontal: MediaQuery.of(context).size.width * 0.007,
            ),
            decoration: BoxDecoration(
              borderRadius:
                  _current == entry.key ? BorderRadius.circular(8.0) : null,
              shape:
                  _current == entry.key ? BoxShape.rectangle : BoxShape.circle,
              color: _current == entry.key
                  ? widget.productCarouselOptions.indicatorsColor ??
                      Colors.red.shade500
                  : Colors.grey.shade800,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget getWrapper(Widget child) {
    Widget wrapper;
    if (widget.productCarouselOptions.height != null) {
      wrapper = SizedBox(
        height: widget.productCarouselOptions.height,
        child: child,
      );
    } else {
      wrapper = AspectRatio(
        aspectRatio: widget.productCarouselOptions.aspectRatio,
        child: child,
      );
    }
    return wrapper;
  }
}
