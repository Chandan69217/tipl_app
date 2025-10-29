import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';



class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final File? selectedFile;
  final String? placeHolder;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const CustomNetworkImage({
    Key? key,
    this.imageUrl,
    this.width = 160,
    this.height = 160,
    this.borderRadius,
    this.selectedFile,
    this.placeHolder = 'assets/logo/profile_holder.webp',
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(100.0),
        child: selectedFile != null ?
        Image.file(
          selectedFile!,
          width: width,
          height: height,
          fit: BoxFit.cover,
        )
            : imageUrl==null || imageUrl!.isEmpty ?  Container(
          decoration: BoxDecoration(
            color: CustColors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(80),
          ),
          child: Image.asset(
            placeHolder??'assets/logo/profile_holder.webp',
            width: width,
            height: height,
            fit: fit,
          ),
        ): CachedNetworkImage(
          imageUrl: imageUrl ?? '',
          width: width,
          height: height,
          fit: fit,
          imageBuilder: (context, imageProvider) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          ),
          placeholder: (context, url) => SizedBox(
            width: width,
            height: height,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
              color: CustColors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(80),
            ),
            child: placeHolder != null
                ? Image.asset(placeHolder!, width: width,height: height,fit: fit,)
                : const Icon(Icons.broken_image, size: 40),
          ),
        )

      // FadeInImage.assetNetwork(
      //   width: width,
      //   height: height,
      //   placeholder: placeHolder??'assets/logo/Placeholder_image.webp',
      //   image: imageUrl!,
      //   fit: fit,
      //   imageErrorBuilder: (context, error, stackTrace) {
      //     return Image.asset(
      //       placeHolder??'assets/logo/Placeholder_image.webp',
      //       width: width,
      //       height: height,
      //       fit: fit,
      //     );
      //   },
      // ),
    );
  }
}