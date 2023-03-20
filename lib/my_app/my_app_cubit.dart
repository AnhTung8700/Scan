import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/model/enum/load_status.dart';

part 'my_app_state.dart';

class MyAppCubit extends Cubit<MyAppState> {
  MyAppCubit() : super(const MyAppState());

  Future<void> selectImage(String imagePath) async {
    try {
      emit(state.copyWith(
        imagePath: imagePath,
      ));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> scanText(XFile image) async {
    emit(state.copyWith(scanTextStatus: LoadStatus.loading));
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textDetector = GoogleMlKit.vision.textDetector();
      RecognisedText recognisedText =
          await textDetector.processImage(inputImage);
      await textDetector.close();
      String scannedText = '';
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          scannedText = "$scannedText${line.text}\n";
        }
      }
      emit(state.copyWith(
        scanTextStatus: LoadStatus.success,
        textScan: scannedText,
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(scanTextStatus: LoadStatus.fail));
    }
  }
}
