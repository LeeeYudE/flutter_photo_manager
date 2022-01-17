import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../util/common_util.dart';
import '../widget/live_photos_widget.dart';
import '../widget/video_widget.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    Key? key,
    required this.entity,
    this.mediaUrl,
  }) : super(key: key);

  final AssetEntity entity;
  final String? mediaUrl;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool? useOrigin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset detail'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showInfo,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          if (widget.entity.type == AssetType.image)
            CheckboxListTile(
              title: const Text('Use origin file.'),
              onChanged: (bool? value) {
                useOrigin = value;
                setState(() {});
              },
              value: useOrigin,
            ),
          Container(
            color: Colors.black,
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (widget.entity.isLivePhoto) {
      return LivePhotosWidget(
        entity: widget.entity,
        mediaUrl: widget.mediaUrl!,
        useOrigin: useOrigin == true,
      );
    }
    if (widget.entity.type == AssetType.video ||
        widget.entity.type == AssetType.audio ||
        widget.entity.isLivePhoto) {
      return buildVideo();
    }
    return buildImage();
  }

  Widget buildImage() {
    return Image(
      image: AssetEntityImageProvider(
        widget.entity,
        isOriginal: useOrigin == true,
      ),
      fit: BoxFit.fill,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? progress,
      ) {
        if (progress == null) {
          return child;
        }
        final double? value;
        if (progress.expectedTotalBytes != null) {
          value = progress.cumulativeBytesLoaded / progress.expectedTotalBytes!;
        } else {
          value = null;
        }
        return Center(
          child: SizedBox.fromSize(
            size: const Size.square(30),
            child: CircularProgressIndicator(value: value),
          ),
        );
      },
    );
  }

  Widget buildVideo() {
    if (widget.mediaUrl == null) {
      return const SizedBox.shrink();
    }
    return VideoWidget(
      isAudio: widget.entity.type == AssetType.audio,
      mediaUrl: widget.mediaUrl!,
    );
  }

  Future<void> _showInfo() {
    return CommonUtil.showInfoDialog(context, widget.entity);
  }

  Widget buildAudio() {
    return const Center(child: Icon(Icons.audiotrack));
  }
}
