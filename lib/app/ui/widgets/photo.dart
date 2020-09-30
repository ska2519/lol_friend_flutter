import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PhotoWidget extends StatelessWidget {
  final String photoLink;

  const PhotoWidget({this.photoLink});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ExtendedImage.network(
      photoLink,
      height: size.height * 0.77,
      fit: BoxFit.cover,
      cache: true,
      enableSlideOutPage: true,
      filterQuality: FilterQuality.low,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Center(child: CircularProgressIndicator());
            break;
          case LoadState.completed:
            return null;
            break;
          case LoadState.failed:
            return GestureDetector(
                child: Center(child: Text("다시 로딩하기")),
                onTap: () {
                  state.reLoadImage();
                });
            break;
        }
        return Text("");
      },
    );
  }
}
