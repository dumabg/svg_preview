import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_utils/widgets/async_state.dart';
import 'package:svg_preview/screens/home/home_controller.dart';
import 'package:svg_preview/util/memory_bytes_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends StateWithController<HomeScreen, HomeController> {
  @override
  HomeController createController() => HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.file_open_rounded),
            tooltip: 'Abrir',
            onPressed: controller.onOpenPressed,
          ),
          IconButton(
            icon: const Icon(Icons.compress),
            tooltip: 'Web para comprimir svg',
            onPressed: controller.onCompressPressed,
          ),
          const Spacer()
        ],
      ),
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: controller.svg,
            builder: (_, value, __) => value == null
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      const SizedBox(height: 30),
                      _svg(SvgPicture.string(
                        value,
                      )),
                      const SizedBox(height: 20),
                      IconButton(
                        icon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.file_download),
                            Text('Compilar svg')
                          ],
                        ),
                        tooltip: 'Compilar svg',
                        onPressed: controller.onCompilePressed,
                      ),
                      const SizedBox(height: 20),
                      ValueListenableBuilder<Uint8List?>(
                          valueListenable: controller.svgCompiled,
                          builder: (_, value, __) => value == null
                              ? const SizedBox.shrink()
                              : _svg(SvgPicture(MemoryBytesLoader(value))))
                    ],
                  )),
      ),
    );
  }

  Widget _svg(Widget child) {
    return Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue)),
        child: child);
  }
}
