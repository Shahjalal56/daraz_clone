import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../products/domain/entity/product_entity.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductEntity product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    loadingBuilder: (_, child, progress) =>
                        progress == null
                            ? child
                            : Container(
                                color: Colors.grey.shade100,
                                child: const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFFF6000))),
                              ),
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade100,
                      child: Icon(Icons.broken_image_outlined,
                          color: Colors.grey, size: 32.sp),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              color: const Color(0xFFFFD700), size: 12.sp),
                          SizedBox(width: 2.w),
                          Text(
                            product.ratingRate.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFF6000),
                      ),
                    ),
                    Text(
                      '${product.ratingCount} sold',
                      style: TextStyle(
                          fontSize: 10.sp, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
