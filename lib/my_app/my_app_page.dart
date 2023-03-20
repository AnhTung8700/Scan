import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/model/enum/load_status.dart';

import 'my_app_cubit.dart';

class MyAppPage extends StatelessWidget {
  const MyAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return MyAppCubit();
      },
      child: const MyAppChildPage(),
    );
  }
}

class MyAppChildPage extends StatefulWidget {
  const MyAppChildPage({Key? key}) : super(key: key);

  @override
  State<MyAppChildPage> createState() => _MyAppChildPageState();
}

class _MyAppChildPageState extends State<MyAppChildPage> {
  final ImagePicker _picker = ImagePicker();
  late MyAppCubit _myAppCubit;

  @override
  void initState() {
    super.initState();
    _myAppCubit = BlocProvider.of<MyAppCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: _buildBodyWidget(),
        ),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          _image(),
          const SizedBox(height: 20),
          _button(),
          const SizedBox(height: 20),
          _scannedText(),
        ],
      ),
    );
  }

  Widget _image() {
    return BlocBuilder<MyAppCubit, MyAppState>(
      bloc: _myAppCubit,
      buildWhen: (previous, current) => previous.imagePath != current.imagePath,
      builder: (context, state) {
        switch (state.loadImage) {
          case LoadStatus.loading:
            return const CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: Colors.white,
            );
          case LoadStatus.fail:
            return const Text(
              "Lỗi",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            );
          default:
            return Container(
              width: 300,
              height: 300,
              color: Colors.blueGrey,
              child: state.imagePath == ''
                  ? const SizedBox.shrink()
                  : Image.file(
                      File(state.imagePath!),
                      fit: BoxFit.cover,
                    ),
            );
        }
      },
    );
  }

  Widget _button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () async {
              final img = await _picker.pickImage(source: ImageSource.gallery);
              if (img != null) {
                await _myAppCubit.selectImage(img.path);
                _myAppCubit.scanText(img);
              }
            },
            child: const Icon(
              Icons.image,
              size: 50,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () async {
              final img = await _picker.pickImage(source: ImageSource.camera);
              if (img != null) {
                await _myAppCubit.selectImage(img.path);
                _myAppCubit.scanText(img);
              }
            },
            child: const Icon(
              Icons.camera,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _scannedText() {
    return BlocBuilder<MyAppCubit, MyAppState>(
      bloc: _myAppCubit,
      buildWhen: (previous, current) =>
          previous.scanTextStatus != current.scanTextStatus,
      builder: (context, state) {
        switch (state.scanTextStatus) {
          case LoadStatus.loading:
            return const CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: Colors.white,
            );

          case LoadStatus.initial:
            return const Text(
              '',
              style: TextStyle(fontSize: 20, color: Colors.black),
            );
          case LoadStatus.fail:
            return const Text(
              'Lỗi',
              style: TextStyle(fontSize: 20, color: Colors.black),
            );
          default:
            return Text(
              state.textScan ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
