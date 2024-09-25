import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/model/restaurant.dart';
import 'package:restaurant/vm/restauranthandler.dart';

class UpdateRestaurant extends StatefulWidget {
  const UpdateRestaurant({super.key});

  @override
  State<UpdateRestaurant> createState() => _UpdateRestaurantState();
}

class _UpdateRestaurantState extends State<UpdateRestaurant> {
  var value = Get.arguments ?? '__';
  late Position currentPosition;
  late int firstDisp;
  XFile? imageFile;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController groupController;
  late TextEditingController representController;
  late TextEditingController commentController;
  final ImagePicker picker = ImagePicker();
  late bool canRun;
  late List location;
  late double latData;
  late double longData;
  Restauranthandler restauranthandler = Restauranthandler();

  @override
  void initState() {
    super.initState();
    firstDisp = 0;
    latData = 0;
    longData = 0;
    checkLocationPermission();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    groupController = TextEditingController();
    representController = TextEditingController();
    commentController = TextEditingController();
    nameController.text = value[2];
    groupController.text = value[1];
    phoneController.text = value[5];
    representController.text = value[6];
    commentController.text = value[7];
  }

  checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      getCurrentLocation();
    }
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    currentPosition = position;
    canRun = true;
    latitudeController.text = value[3].toString();
    longitudeController.text = value[4].toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('맛집 수정'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        getImageFromGallery(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                      child: const Text('Image'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.7,
                    height: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: firstDisp == 0
                        ? Center(child: Image.memory(value[8]))
                        : imageFile == null
                            ? const Text('Image is not selected')
                            : Image.file(File(imageFile!.path)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Row(
                          children: [
                            const Text(
                              '위치 : ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                height: MediaQuery.of(context).size.width / 9,
                                width: MediaQuery.of(context).size.width / 3.5,
                                child: TextField(
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                  readOnly: true,
                                  controller: latitudeController,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              height: MediaQuery.of(context).size.width / 9,
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                                readOnly: true,
                                textAlign: TextAlign.center,
                                controller: longitudeController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Row(
                            children: [
                              const Text(
                                '이름 : ',
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 20, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  height: MediaQuery.of(context).size.width / 9,
                                  width:
                                      MediaQuery.of(context).size.width / 1.6,
                                  child: TextField(
                                    controller: nameController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Row(
                            children: [
                              const Text(
                                '전화 : ',
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 20, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  height: MediaQuery.of(context).size.width / 9,
                                  width:
                                      MediaQuery.of(context).size.width / 1.6,
                                  child: TextField(
                                    controller: phoneController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1,
                          child: Row(
                            children: [
                              const Text(
                                '카테고리 : ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 20, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  height: MediaQuery.of(context).size.width / 9,
                                  width:
                                      MediaQuery.of(context).size.width / 1.6,
                                  child: TextField(
                                    controller: groupController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1,
                          child: Row(
                            children: [
                              const Text(
                                '대표 음식: ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 20, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  height: MediaQuery.of(context).size.width / 9,
                                  width:
                                      MediaQuery.of(context).size.width / 1.6,
                                  child: TextField(
                                    controller: representController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '평가 : ',
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 20, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  width:
                                      MediaQuery.of(context).size.width / 1.6,
                                  child: TextField(
                                    minLines: 4,
                                    maxLines: 15,
                                    controller: commentController,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            Restaurant restaurant = Restaurant(
                                id: value[0],
                                name: nameController.text.trim(),
                                group: groupController.text.trim(),
                                latitude: double.parse(
                                    latitudeController.text.trim()),
                                longitude: double.parse(
                                    longitudeController.text.trim()),
                                phone: phoneController.text.trim(),
                                represent: representController.text.trim(),
                                comment: commentController.text.trim(),
                                image: imageFile == null
                                    ? value[8]
                                    : await File(imageFile!.path)
                                        .readAsBytes());
                            await updateRestaurant(restaurant);
                          },
                          child: const Text('수정'))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      imageFile = XFile(pickedFile.path);
      firstDisp += 1;
    }
    setState(() {});
  }

  updateRestaurant(Restaurant restaurant) async {
    Get.back();
    int result = await restauranthandler.updateRestaurant(restaurant);
    if(result == 0){
      Get.snackbar('에러', '데이터가 입력되지 않았습니다.',backgroundColor: Colors.red);
    }
    setState(() {
      
    });
  }
}
