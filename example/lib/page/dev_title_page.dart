import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class DevelopingExample extends StatefulWidget {
  @override
  _DevelopingExampleState createState() => _DevelopingExampleState();
}

class _DevelopingExampleState extends State<DevelopingExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: RaisedButton(
          child: Text("Test title speed"),
          onPressed: () async {
            final start = DateTime.now();
            int count = 10000;
            var result = await PhotoManager.requestPermission();
            if (result) {
              List<AssetEntity> imageList = [];
              List<AssetPathEntity> list = await PhotoManager.getImageAsset();
              if (list != null)
                for (AssetPathEntity path in list)
                  imageList.addAll(await path.getAssetListRange(
                      start: 0, end: path.assetCount));

              if (imageList.isNotEmpty) {
                imageList.shuffle();

                List<AssetEntity> imageListNew = imageList.length > count
                    ? imageList.sublist(0, count)
                    : imageList;

                List<AssetEntity> data = [];

                for (AssetEntity assetEntity in imageListNew)
                  data.add(assetEntity);
              }
            }
            final diff = DateTime.now().difference(start);
            print(diff);
          },
        ),
      ),
    );
  }
}
