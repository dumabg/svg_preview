import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class MemoryBytesLoader extends BytesLoader {
  final Uint8List data;

  const MemoryBytesLoader(this.data);

  @override
  Future<ByteData> loadBytes(BuildContext? context) async {
    return ByteData.view(data.buffer);
  }
}
