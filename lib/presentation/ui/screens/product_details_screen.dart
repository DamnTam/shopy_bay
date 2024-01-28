import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopy_bay/data/models/product_details_model.dart';
import 'package:shopy_bay/presentation/ui/screens/review_screen.dart';
import 'package:shopy_bay/presentation/ui/widgets/product_details/products_details_carousel.dart';

import '../../../controller/product_details_controller.dart';
import '../utility/app_colors.dart';
import '../widgets/product_details/color_selector.dart';
import '../widgets/product_details/size_selector.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.id});

  final int id;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initStatee
    super.initState();
    Get.find<ProductDetailsController>().getProductDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: GetBuilder<ProductDetailsController>(
                  builder: (productDetailsController) {
                return Column(
                  children: [
                    ProductDetailsCarousel(onTap: () {}, imageUrls: [
                      productDetailsController.productDetails.img1 ?? '',
                      productDetailsController.productDetails.img2 ?? '',
                      productDetailsController.productDetails.img3 ?? '',
                      productDetailsController.productDetails.img4 ?? '',
                    ]),
                    const SizedBox(height: 10),
                    Visibility(
                        visible: productDetailsController.isLoading == false,
                        replacement:
                            const Center(child: LinearProgressIndicator()),
                        child: ProductDetailsBody(
                          productDetails:
                              productDetailsController.productDetails,
                        )),
                  ],
                );
              }),
            ),
          ),
          buildCheckoutContainer
        ],
      ),
    );
  }

  Container get buildCheckoutContainer {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '\$150.00',
                  style: TextStyle(
                      fontSize: 24,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text('Add to Cart'),
                ))
          ],
        ),
      ),
    );
  }
}

class ProductDetailsBody extends StatefulWidget {
  const ProductDetailsBody({super.key, required this.productDetails});

  final ProductDetails productDetails;

  @override
  State<ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<ProductDetailsBody> {
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];
  final List<String> _sizes = [
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];
  String isSelectedSize = 'S';
  Color isSelectedColor = Colors.purple;
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                widget.productDetails.product?.title ?? '',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              )),
              InkWell(
                onTap: () {
                  setState(() {
                    if (counter > 1) counter--;
                  });
                },
                child: buildCounterContainer(
                    icon: const Icon(Icons.remove),
                    color: counter == 1 ? Colors.grey : AppColors.primaryColor),
              ),
              const SizedBox(width: 5),
              Text('$counter', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  setState(() {
                    counter++;
                  });
                },
                child: buildCounterContainer(
                    icon: const Icon(Icons.add), color: AppColors.primaryColor),
              )
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 24,
              ),
              Text(
                widget.productDetails.product?.star?.toStringAsFixed(2) ?? '',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Get.to(() => ReviewScreen());
                },
                child: Text(
                  'Reviews',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 10),
              Card(
                color: AppColors.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          ColorSelector(
              colors: _colors,
              onTap: (isSelectedColor) {
                isSelectedColor = isSelectedColor;
              }),
          const SizedBox(height: 10),
          const Text('Size',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          SizeSelector(
              sizes: widget.productDetails.size!.split(','),
              onTap: (isSelectedSize) {
                isSelectedSize = isSelectedSize;
              }),
          const SizedBox(height: 10),
          const Text('Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(
            widget.productDetails.product?.shortDes ?? '',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Card buildCounterContainer({
    required Icon icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      color: color,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        child: icon,
      ),
    );
  }
}
