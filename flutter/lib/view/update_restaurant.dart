import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/vm/restauranthandler.dart';
import 'package:http/http.dart' as http;

class UpdateRestaurant extends StatefulWidget {
  const UpdateRestaurant({super.key});

  @override
  State<UpdateRestaurant> createState() => _UpdateRestaurantState();
}

class _UpdateRestaurantState extends State<UpdateRestaurant> {
  var value = Get.arguments ?? '__';
  late Position currentPosition;
  late int firstDisp;
  XFile? imageFile; //IMG
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController groupController;
  late TextEditingController representController;
  late TextEditingController commentController;
  final ImagePicker picker = ImagePicker(); //IMG
  late bool canRun;
  late List location;
  late double latData;
  late double longData;
  Restauranthandler restauranthandler = Restauranthandler();

  //——hjy———ImagePicker에서 선택된 filename————————————————
  String filename = "";
  //——————————————————————————————————————

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
    nameController.text = value[3];
    groupController.text = value[1];
    phoneController.text = value[7];
    representController.text = value[8];
    commentController.text = value[9];
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
    latitudeController.text = value[4].toString();
    longitudeController.text = value[5].toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('맛집 정보 수정'),
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

//---hjy수정---------------------------------------------------------------------
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.7,
                    height: 150,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: firstDisp == 0
                        ? Center(
                            child: Image.network(
                                "http://127.0.0.1:8000/image/view/${value[6]}"))
                        : imageFile == null
                            ? const Text('Image is not selected')
                            : Image.file(File(imageFile!.path)),
                  ),
//------------------------------------------------------------------------------
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
                          onPressed: () {
                            if (imageFile == null) {
                              updateJSONData();
                            } else {
                              updateJSONDataAll();
                            }
                          },
                          // onPressed: () async {
                          //   Restaurant restaurant = Restaurant(
                          //       id: value[0],
                          //       name: nameController.text.trim(),
                          //       group: groupController.text.trim(),
                          //       latitude: double.parse(
                          //           latitudeController.text.trim()),
                          //       longitude: double.parse(
                          //           longitudeController.text.trim()),
                          //       phone: phoneController.text.trim(),
                          //       represent: representController.text.trim(),
                          //       comment: commentController.text.trim(),
                          //       image: imageFile == null
                          //           ? value[8]
                          //           : await File(imageFile!.path)
                          //               .readAsBytes());
                          //   await updateRestaurant(restaurant);
                          // },
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

//—hjy수정——————————————————————————————————
  getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    imageFile = XFile(pickedFile!.path);
    firstDisp = 1; //수정할때
    setState(() {});
    print(imageFile!.path); //이미지 경로 확인
  }

//———————————————————————————————————————

  // updateRestaurant(Restaurant restaurant) async {
  //   Get.back();
  //   int result = await restauranthandler.updateRestaurant(restaurant);
  //   if (result == 0) {
  //     Get.snackbar('에러', '데이터가 입력되지 않았습니다.', backgroundColor: Colors.red);
  //   }
  //   setState(() {});
  // }

//—hjy수정——————————————————————————————————

  uploadImage() async{
    var request = http.MultipartRequest("POST", Uri.parse("http://127.0.0.1:8000/image/upload"));
    var multipartFile = await http.MultipartFile.fromPath('file', imageFile!.path);
    request.files.add(multipartFile);
    List preFileName = imageFile!.path.split('/');
    filename = preFileName[preFileName.length - 1];
    print("upload filename : ${filename}");
    var response = await request.send();
    if(response.statusCode == 200){
      print('success');
    }else{
      print("error");
    }
  }


  updateJSONData() async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/update?seq=${value[0]}&category_id=${value[1]}&user_seq${value[2]}&name=${nameController.text}&latitude=${double.parse(latitudeController.text)}&longitude=${double.parse(longitudeController.text)}&phone=${phoneController.text}&represent=${representController.text}&memo=${commentController.text}&favorite=${value[10]}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == 'OK') {
      _showDialog();
    } else {
      errorSnackBar();
    }
  }



  updateJSONDataAll() async {
    await uploadImage();
    var url = Uri.parse(
        'http://127.0.0.1:8000/update/all?seq=${value[0]}&category_id=${value[1]}&user_seq=${value[2]}&name=${nameController.text}&latitude=${double.parse(latitudeController.text)}&longitude=${double.parse(longitudeController.text)}&image=${filename}&phone=${phoneController.text}&represent=${representController.text}&memo=${commentController.text}&favorite=${value[10]}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    if (result == 'OK') {
      _showDialog();
    } else {
      errorSnackBar();
    }
  }

  _showDialog() {
    Get.defaultDialog(
      title: '입력 결과',
      middleText: '입력이 완료되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('확인'),
        )
      ],
    );
  }

  errorSnackBar() {
    Get.snackbar(
      "Error",
      "데이터를 확인하세요",
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
      colorText: Colors.amber,
    );
  }
}
//———————————————————————————————————————
