import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';


class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewerScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 5.0,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => Center(
                child: CustomCircularIndicator(),
              ),
              errorWidget: (context, url, error) =>
              const Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, color: Colors.red,size: 60,),
                  const SizedBox(height: 12,),
                  Text("We couldn’t load this document right now.")
                ],
              )),
              imageBuilder: (context, imageProvider) => SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}