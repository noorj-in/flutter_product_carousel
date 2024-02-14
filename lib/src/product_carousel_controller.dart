import 'package:flutter/cupertino.dart';

abstract class ProductCarouselController {

  /// Moves the page view to the next page.
  Future<void> nextPage({Duration? duration, Curve? curve});

  /// Moves the page view to the previous page.
  Future<void> previousPage({Duration? duration, Curve? curve});

  /// Factory constructor for the ProductCarouselController
  factory ProductCarouselController() {
    return ProductCarouselControllerImpl();
  }
}

class ProductCarouselControllerImpl implements ProductCarouselController {
  PageController? pageController;

  @override
  Future<void> nextPage({Duration? duration, Curve? curve}) async {
    await pageController?.nextPage(
        duration: duration ?? const Duration(milliseconds: 600),
        curve: curve ?? Curves.easeInToLinear);
  }

  @override
  Future<void> previousPage({Duration? duration, Curve? curve}) async {
    await pageController?.previousPage(
        duration: duration ?? const Duration(milliseconds: 600),
        curve: curve ?? Curves.easeInToLinear);
  }
}
