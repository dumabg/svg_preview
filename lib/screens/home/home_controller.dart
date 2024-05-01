import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart';

class HomeController {
  static String? _lastDirectorySelected;

  final svg = ValueNotifier<String?>(null);
  final svgCompiled = ValueNotifier<Uint8List?>(null);
  File? _svgFile;

  HomeController() {
    initializeLibPathOps(
        '/opt/flutter/bin/cache/artifacts/engine/linux-x64/libpath_ops.so');
  }

  Future<void> onOpenPressed() async {
    final FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(
      initialDirectory: _lastDirectorySelected,
      dialogTitle: 'Selecionar svg',
      type: FileType.custom,
      allowedExtensions: ['svg'],
    );
    if (filePickerResult != null) {
      final String? path = filePickerResult.files.first.path;
      if (path != null) {
        final File file = File(path);
        _lastDirectorySelected = file.parent.path;
        _svgFile = file;
        svg.value = await file.readAsString();
      }
      svgCompiled.value = null;
    }
  }

  void onCompressPressed() {
    unawaited(launchUrlString('https://vecta.io/nano',
        mode: LaunchMode.externalApplication));
  }

  void onCompilePressed() {
    final String? svgXml = svg.value;
    if (svgXml != null) {
      assert(_svgFile != null);
      final Uint8List data = encodeSvg(
        xml: svgXml,
        debugName: 'HomeController.Compile',
        warningsAsErrors: true,
      );
      svgCompiled.value = data;
      File('${_svgFile!.path}.vec').writeAsBytesSync(data, flush: true);
    }
  }
}
