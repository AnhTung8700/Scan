part of 'my_app_cubit.dart';

class MyAppState extends Equatable {
  final LoadStatus scanTextStatus;
  final LoadStatus loadImage;
  final String? imagePath;
  final String? textScan;

  const MyAppState({
    this.scanTextStatus = LoadStatus.initial,
    this.loadImage = LoadStatus.initial,
    this.imagePath = '',
    this.textScan = '',
  });

  @override
  List<Object?> get props => [
        scanTextStatus,
        loadImage,
        imagePath,
        textScan,
      ];

  MyAppState copyWith({
    LoadStatus? scanTextStatus,
    LoadStatus? loadImage,
    String? imagePath,
    String? textScan,
  }) {
    return MyAppState(
      scanTextStatus: scanTextStatus ?? this.scanTextStatus,
      loadImage: loadImage ?? this.loadImage,
      imagePath: imagePath ?? this.imagePath,
      textScan: textScan ?? this.textScan,
    );
  }
}
