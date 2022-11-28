import 'package:flutter/material.dart';

class CameraAppBar extends StatelessWidget with PreferredSizeWidget {
  const CameraAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40.0);
}
