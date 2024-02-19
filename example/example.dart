import 'package:flutter/material.dart';
import 'package:flutter_product_carousel/src/product_carousel_options.dart';
import 'package:flutter_product_carousel/src/product_carousel_controller.dart';
import 'package:flutter_product_carousel/flutter_product_carousel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Product Carousel Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductCarouselTest(),
      // home:  DemoPage(title: 'Image 360 View'),
    );
  }
}

class ProductCarouselTest extends StatefulWidget {
  const ProductCarouselTest({super.key});

  @override
  State<ProductCarouselTest> createState() => _ProductCarouselTestState();
}

class _ProductCarouselTestState extends State<ProductCarouselTest> {
  final ProductCarouselController _productCarouselController =
      ProductCarouselController();
  bool preView = false;

  int currentPage = 0;
  bool isFavorite = false;

  List<ImageProvider> imageList = <ImageProvider>[];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateImageList(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Carousel'),
        elevation: 2,
      ),
      body: ProductCarousel(
        imagesList: const [
          'https://images.stockx.com/images/Air-Jordan-3-Retro-Muslin-Product.jpg?fit=fill&bg=FFFFFF&w=140&h=75&fm=avif&auto=compress&dpr=2&trim=color&updated_at=1648503692&q=60',
          'https://images.stockx.com/images/Air-Jordan-3-Retro-Infrared-23-V2-Product.jpg?fit=fill&bg=FFFFFF&w=140&h=75&fm=avif&auto=compress&dpr=2&trim=color&updated_at=1659538591&q=60',
          'https://images.stockx.com/images/Air-Jordan-3-Retro-Racer-Blue-Product.jpg?fit=fill&bg=FFFFFF&w=140&h=75&fm=avif&auto=compress&dpr=2&trim=color&updated_at=1626802534&q=60',
          'https://images.stockx.com/images/Air-Jordan-3-Retro-Chlorophyll-Product.jpg?fit=fill&bg=FFFFFF&w=140&h=75&fm=avif&auto=compress&dpr=2&trim=color&updated_at=1607663359&q=60',
          'https://images.stockx.com/images/Air-Jordan-3-Retro-Stealth-Product.jpg?fit=fill&bg=FFFFFF&w=140&h=75&fm=avif&auto=compress&dpr=2&trim=color&updated_at=1607662925&q=60'
        ],
        multiImagesList: imageList,
        carouselOptions: ProductCarouselOptions(
          autoPlay: true,
          aspectRatio: 10 / 9,
          productCarouselController: _productCarouselController,
          showNavigationIcons: true,
          enabledInfiniteScroll: true,
          isFavorite: isFavorite,
          previewImages: preView,
          onTap: () {
            setState(() {
              preView = !preView;
            });
          },
          onFavoriteTap: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
          onShareTap: () {
            print('Share button pressed');
          },
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
        ),
      ),
    );
  }

  void updateImageList(BuildContext context) async {
    String img = '';
    for (int i = 1; i <= 35; i++) {
      if (i < 10) {
        img = 'img0$i.jpg';
      } else {
        img = 'img$i.jpg';
      }

      imageList.add(NetworkImage(
          'https://images.stockx.com/360/Air-Jordan-3-Retro-Craft-Ivory/Images/Air-Jordan-3-Retro-Craft-Ivory/Lv2/$img?'));
    }
    await Future.delayed(const Duration(milliseconds: 1100));
    setState(() {});
  }
}
