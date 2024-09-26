import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/model/category.dart';
import 'package:restaurant/model/restaurant.dart';
import 'package:restaurant/vm/categoryhandler.dart';
import 'package:restaurant/vm/restauranthandler.dart';
import 'package:http/http.dart' as http;

class AddRestaurant extends StatefulWidget {
  const AddRestaurant({super.key});

  @override
  State<AddRestaurant> createState() => _AddRestaurantState();
}

class _AddRestaurantState extends State<AddRestaurant> {
  final box = GetStorage();
  int? userSeq;  ///////////// 나중에 꼭 바꿔주세요!
  String? imageName;
  Categoryhandler categoryhandler = Categoryhandler();
  Restauranthandler restauranthandler = Restauranthandler();



  List<String> categories = [];
  String? selectedValue;
  late Position currentPosition;
  XFile? imageFile;
  String filename = "";
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController representController;
  late TextEditingController commentController;
  final ImagePicker picker = ImagePicker();
  late bool canRun;
  late List location;
  late double latData;
  late double longData;

  @override
  void initState() {
    super.initState();
    userSeq = 1;
    latData = 0;
    longData = 0;
    checkLocationPermission();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    representController = TextEditingController();
    commentController = TextEditingController();

    yahoo();

  }

  yahoo()async{
    List<Category> wow = await categoryhandler.getCategory();

    for(Category category in wow){
      categories.add(category.id);
    }
    setState(() {});
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
    latitudeController.text = currentPosition.latitude.toString();
    longitudeController.text = currentPosition.longitude.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          '맛집 추가',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.7,
                          height: 150,
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: Center(
                              child: imageFile == null
                                  ? ElevatedButton(
                                      onPressed: () {
                                        getImageFromGallery(ImageSource.gallery);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10))),
                                      child: const Text('사진 업로드'),
                                    )
                                  : Image.file(File(imageFile!.path))),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 720,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 23, 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '위치',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(8, 8, 30, 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                                border:
                                                    Border.all(color: Colors.black)),
                                            height:
                                                MediaQuery.of(context).size.width / 9,
                                            width:
                                                MediaQuery.of(context).size.width / 3,
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
                                            borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.black)),
                                          height: MediaQuery.of(context).size.width / 9,
                                          width:
                                              MediaQuery.of(context).size.width / 3,
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
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '이름',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.black)),
                                            height: MediaQuery.of(context).size.width / 9,
                                            width:
                                                MediaQuery.of(context).size.width / 1.25,
                                            child: TextField(
                                              controller: nameController,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '전화번호',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.black)),
                                            height: MediaQuery.of(context).size.width / 9,
                                            width:
                                                MediaQuery.of(context).size.width / 1.25,
                                            child: TextField(
                                              keyboardType: TextInputType.phone,
                                              controller: phoneController,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '분류',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.black)),
                                            height: MediaQuery.of(context).size.width / 9,
                                            width:
                                                MediaQuery.of(context).size.width / 1.25,
                                            child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                hint: const Text('분류'),
                                items: categories.map((String categories) =>
                                        DropdownMenuItem<String>(
                                          value: categories,
                                          child: Text(categories),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 45,
                                  width: 80,
                                ),
                              )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),



                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '대표음식',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.black)),
                                            height: MediaQuery.of(context).size.width / 9,
                                            width:
                                                MediaQuery.of(context).size.width / 1.25,
                                            child: TextField(
                                              controller: representController,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '메모',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.black)),
                                            width:
                                                MediaQuery.of(context).size.width / 1.25,
                                            height: 190,
                                            child: TextField(
                                              minLines: 8,
                                              maxLines: 20,
                                              controller: commentController,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: ElevatedButton(
                        onPressed: () async {
                          Restaurant restaurant = Restaurant(
                              category_id: selectedValue!,
                              user_seq: userSeq!,
                              name: nameController.text.trim(),
                              latitude:
                                  double.parse(latitudeController.text.trim()),
                              longitude:
                                  double.parse(longitudeController.text.trim()),
                              image: imageName!,
                              phone: phoneController.text.trim(),
                              represent: representController.text.trim(),
                              memo: commentController.text.trim(),
                              favorite: false);
                          await addRestaurant(restaurant);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondaryContainer),
                        child: const Text('추가 하기')),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadImage() async{
    var request = http.MultipartRequest("POST", Uri.parse("http://127.0.0.1:8000/image/upload"));
    var multipartFile = await http.MultipartFile.fromPath('file', imageFile!.path);
    request.files.add(multipartFile);
    List preFileName = imageFile!.path.split('/');
    filename = preFileName[preFileName.length - 1];
    print("upload filename : $filename");
    var response = await request.send();
    if(response.statusCode == 200){
      print('success');
    }else{
      print("error");
    }
  }

  Future getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      imageFile = XFile(pickedFile.path);
      List preFileName = imageFile!.path.split('/');
      imageName = preFileName[preFileName.length-1];
    }

    setState(() {});
  }

  addRestaurant(Restaurant restaurant) async {
    Get.back();
    await uploadImage();
    restauranthandler.insertRestaurant(restaurant);
    // int result = await restauranthandler.insertRestaurant(restaurant);
    // if (result == 0) {
    //   Get.snackbar('에러', '데이터가 입력되지 않았습니다.', backgroundColor: Colors.red);
    // }
    setState(() {});
  }
}
