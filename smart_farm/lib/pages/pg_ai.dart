import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_farm/pages/app_widgets.dart';
import 'package:smart_farm/values/app_assets.dart';
import 'package:smart_farm/values/app_colors.dart';
import 'package:smart_farm/values/app_styles.dart';
import 'package:smart_farm/main.dart';

class AppPageAI extends StatefulWidget {
  const AppPageAI({super.key});

  @override
  State<AppPageAI> createState() => _AppPageAIState();
}

class _AppPageAIState extends State<AppPageAI> {
  File? filePath;

  double confidence = 0.0;
  String label = '';

  Future<void> _initTFLite() async {
    // Load TFLite model
    String? res = await Tflite.loadModel(
      model: AppAIModel.ai_modelPath,
      labels: AppAIModel.ai_labelPath,
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );

    if (res == null) {
      logger.i('===AI===Error loading model');
    } else {
      logger.i('===AI===Model loaded: $res');
    }
  }

  pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image from gallery
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 3,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
      asynch: true,
    );

    if (recognitions == null) {
      logger.i('Cannot recognize the image');
      return;
    }

    logger.i(recognitions);
    setState(() {
      label = recognitions[0]['label'];
      confidence = double.parse((recognitions[0]['confidence'] * 100).toStringAsFixed(2));
    });
  }

  pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image from gallery
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

     if (image == null) return;

     var imageMap = File(image.path);

     setState(() {
       filePath = imageMap;
     });

     var recognitions = await Tflite.runModelOnImage(
       path: image.path,
       numResults: 3,
       threshold: 0.5,
       imageMean: 127.5,
       imageStd: 127.5,
       asynch: true,
     );

     if (recognitions == null) {
       logger.i('Cannot recognize the image');
       return;
     }

     logger.i(recognitions);
     setState(() {
        label = recognitions[0]['label'];
        confidence = double.parse((recognitions[0]['confidence'] * 100).toStringAsFixed(2));
     });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTFLite();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Chẩn bệnh"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Card(
                color: AppColors.lightGrey,
                elevation: 10,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 350,
                  child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Chẩn bệnh cây cà chua\ntừ triệu chứng lá',
                              textAlign: TextAlign.center,
                              style: AppStyles.textSemiBold14.copyWith(
                                fontSize: 20,
                                color: AppColors.black
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(AppImages.img_upload),
                              ),
                            ),
                            child: filePath == null ? const Text('') : Image.file(filePath!, fit: BoxFit.fill),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Bệnh: $label',
                                    textAlign: TextAlign.center,
                                    style: AppStyles.textSemiBold14.copyWith(
                                      fontSize: 20,
                                      color: AppColors.black
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Độ chính xác: $confidence%',
                                  style: AppStyles.textRegular14.copyWith(
                                      fontSize: 18,
                                      color: AppColors.black
                                  ),
                                ),
                              ],
                            )
                          ),
                        ]
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  pickImageCamera();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColors.primaryGreen,
                ),
                child: Text(
                  'Chụp ảnh',
                  style: AppStyles.textSemiBold14.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  pickImageGallery();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColors.primaryGreen,
                ),
                child: Text(
                  'Chọn từ thư viện',
                  style: AppStyles.textSemiBold14.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
