import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:restaurant/model/restaurant.dart';
import 'package:restaurant/view/add_restaurant.dart';
import 'package:restaurant/view/restaurant_location.dart';
import 'package:restaurant/view/search_restaurant.dart';
import 'package:restaurant/view/update_restaurant.dart';
// import 'package:restaurant/vm/favoritehandler.dart';
import 'package:restaurant/vm/restauranthandler.dart';

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key});

  @override
  State<RestaurantList> createState() => _RestaurantListState();
}

class _RestaurantListState extends State<RestaurantList> {
  Restauranthandler restauranthandler = Restauranthandler();
  // Favoritehandler favoritehandler = Favoritehandler();
  late List<String> categories;
  String? selectedValue;
  late String keyword;
  List data = [];
  @override
  void initState() {
    super.initState();
    keyword = '전체';
    categories = [
      '전체',
    ];
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
                                  ))
                              .toList(),
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
                  child: ListView.builder(
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
                                          snapshot.data![index].id!,
                                          snapshot.data![index].group,
                                          snapshot.data![index].name,
                                          snapshot.data![index].latitude,
                                          snapshot.data![index].longitude,
                                          snapshot.data![index].phone,
                                          snapshot.data![index].represent,
                                          snapshot.data![index].comment,
                                          snapshot.data![index].image,
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
                                builder: (context) => CupertinoActionSheet(
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
                                        // favoritehandler.insertFavoriteRestaurant(
                                        //   Restaurant(
                                        //     seq: snapshot.data![index].seq,
                                        //     category_id: snapshot.data![index].category_id,
                                        //     user_seq: snapshot.data![index].user_seq,
                                        //     name: snapshot.data![index].name, 
                                        //     latitude: snapshot.data![index].latitude, 
                                        //     longitude: snapshot.data![index].longitude, 
                                        //     image: snapshot.data![index].image,
                                        //     phone: snapshot.data![index].phone, 
                                        //     represent: snapshot.data![index].represent, 
                                        //     memo: snapshot.data![index].comment, 
                                        //     favorite: snapshot.data![index] == "1" ? true : false
                                        //     )
                                        //   );
                                          Get.back();
                                      },
                                      child: const Text(
                                        '예',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                      onPressed: () => Get.back(),
                                      child: const Text(
                                        '아니오',
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ),
                              );
                            },
                            onTap: () =>
                                Get.to(const RestaurantLocation(), arguments: [
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
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Image.memory(
                                            snapshot.data![index].image,
                                            width: 80,
                                            height: 80,
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 10),
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
