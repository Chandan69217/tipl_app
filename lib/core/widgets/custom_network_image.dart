import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';



class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final File? selectedFile;
  final IconData? placeHolder;
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
    this.placeHolder,
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
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: CustColors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(80),
          ),
          child: Icon(
            placeHolder??Iconsax.profile_circle,
            size: width,
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
          placeholder: (context, url) => Container(
            width: width,
            height: height,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: CustColors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(80),
            ),
            child: placeHolder != null
                ? Icon(placeHolder!, size: width,)
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