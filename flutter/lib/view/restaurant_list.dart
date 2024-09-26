import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurant/model/restaurant.dart';
import 'package:restaurant/view/add_restaurant.dart';
import 'package:restaurant/view/restaurant_location.dart';
import 'package:restaurant/view/search_restaurant.dart';
import 'package:restaurant/view/update_restaurant.dart';
import 'package:restaurant/vm/categoryhandler.dart';
import 'package:restaurant/vm/restauranthandler.dart';
import 'package:restaurant/vm/userhandler.dart';
import 'package:http/http.dart' as http;

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key});

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  final box = GetStorage();
  Restauranthandler restauranthandler = Restauranthandler();
  Categoryhandler categoryhandler = Categoryhandler();
  Userhandler userhandler = Userhandler();
  late List<String> categories;
  String? selectedValue;
  late String keyword;
  List data = [];
  String? userId;
  String? userSeq;
  @override
  void initState() {
    super.initState();
    keyword = '전체';
    categories = [
      '전체',
    ];
    initStorage();
    firstRun();
    getCategory();
  }

  getCategory() async {
    var temp = await categoryhandler.getCategory();
    for (int i = 0; i < temp.length; i++) {
      categories.add(temp[i].id);
    }
  }

  initStorage() {
    if (box.read('state') == '1') {
      return;
    } else {
      box.write('state', '0');
      box.write('user_seq', '0');
    }
  }

  firstRun() async {
    if (box.read('state') == '0') {
      userId = await userhandler.initUser();
      box.write('state', '1');
      userSeq = await userhandler.getSeq(userId);
    } else {
      box.write('user_seq', userSeq);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          '나의 맛집 리스트',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(const SearchRestaurant(),
                    transition: Transition.topLevel,
                    duration: const Duration(milliseconds: 800))!
                .then(
              (value) => reloadData(),
            ),
            icon: Icon(
              Icons.search,
              size: 25,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: () => Get.to(const AddRestaurant(),
                      transition: Transition.downToUp,
                      duration: const Duration(milliseconds: 800),
                      arguments: categories)!
                  .then(
                (value) => reloadData(),
              ),
              icon: Icon(
                Icons.add_outlined,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: keyword == '전체'
            ? restauranthandler.getAllRestaurant()
            : restauranthandler.getRestaurantbyC(selectedValue!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                          hint: const Text('분류'),
                          items: categories
                              .map((String categories) =>
                                  DropdownMenuItem<String>(
                                    value: categories,
                                    child: Text(categories),
                                  )).toList(),
                          value: selectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue = value;
                              keyword = value!;
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
                SizedBox(
                  height: 570,
                  child: snapshot.data!.isEmpty
                      ? const Center(
                          child: Text(
                            '선택한 카테고리의 맛집이 없습니다.',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Slidable(
                                startActionPane: ActionPane(
                                    extentRatio: 0.3,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        flex: 1,
                                        onPressed: (context) {
                                          Get.to(const UpdateRestaurant(),
                                                  arguments: [
                                                snapshot.data![index]['seq'],
                                                snapshot.data![index]
                                                    ['category_id'],
                                                snapshot.data![index]
                                                    ['user_seq'],
                                                snapshot.data![index]['name'],
                                                snapshot.data![index]
                                                    ['latitude'],
                                                snapshot.data![index]
                                                    ['longitude'],
                                                snapshot.data![index]['image'],
                                                snapshot.data![index]['phone'],
                                                snapshot.data![index]
                                                    ['represent'],
                                                snapshot.data![index]['memo'],
                                                snapshot.data![index]
                                                    ['favorite'],
                                              ])!
                                              .then(
                                            (value) => reloadData(),
                                          );
                                        },
                                        backgroundColor: Colors.green,
                                        icon: Icons.edit,
                                        label: '수정',
                                      ),
                                    ]),
                                endActionPane: ActionPane(
                                    extentRatio: 0.3,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        flex: 1,
                                        onPressed: (context) async {
                                          await checkDelete(
                                            snapshot.data![index].id,
                                            snapshot.data![index].user_seq,
                                          );
                                          reloadData();
                                        },
                                        backgroundColor: Colors.red,
                                        icon: Icons.delete_outline_outlined,
                                        label: '삭제',
                                      ),
                                    ]),
                                child: GestureDetector(
                                  onLongPress: () {
                                    showCupertinoModalPopup(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                        title: const Text(
                                          '즐겨찾기',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        message: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            '즐겨찾기에 추가하시겠습니까?',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        actions: [
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                             updateJSONData(snapshot.data![index]);
                                              Get.back();
                                            },
                                            child: const Text(
                                              '예',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                                onPressed: () => Get.back(),
                                                child: const Text(
                                                  '아니오',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                      ),
                                    );
                                  },
                                  onTap: () => Get.to(
                                      const RestaurantLocation(),
                                      arguments: [
                                        snapshot.data![index].latitude,
                                        snapshot.data![index].longitude,
                                        snapshot.data![index].name,
                                      ]),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                                    child: Card(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Image.network(
                                                  'http://127.0.0.1:8000/image/view/${snapshot.data![index].image}',
                                                  fit: BoxFit.cover,
                                                  width: MediaQuery.of(context).size.width / 3.5,
                                                  height: MediaQuery.of(context).size.height / 10,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 10),
                                                    child: Text(
                                                        '매장명 : ${snapshot.data![index].name}'),
                                                  ),
                                                  Text(
                                                      '매장 번호 : ${snapshot.data![index].phone}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('저장된 맛집이 없습니다.'),
            );
          }
        },
      ),
    );
  }

  reloadData() {
    setState(() {});
  }

  updateJSONData(Restaurant restaurant) async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/update?seq=${restaurant.seq}&category_id=${restaurant.category_id}&user_seq=${restaurant.user_seq}&name=${restaurant.name}&latitude=${restaurant.latitude}&longitude=${restaurant.longitude}&image=${restaurant.image}&phone=${restaurant.phone}&represent=${restaurant.represent}&memo=${restaurant.memo}&favorite=1');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['result'];
    setState(() {});
    print(result);
  }

  checkDelete(int seq, int user_seq) async {
    Get.defaultDialog(title: '경고', middleText: '정말 삭제하시겠습니까?', actions: [
      Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.brown[50]),
                child: const Text('아니오')),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: TextButton(
              onPressed: () async {
                Get.back();
                await restauranthandler.deleteRestaurant(seq, user_seq);
                setState(() {});
              },
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.brown[300]),
              child: const Text('예'),
            ),
          ),
        ],
      ),
    ]);
  }
}
