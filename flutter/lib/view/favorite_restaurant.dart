import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/view/restaurant_location.dart';
import 'package:restaurant/vm/restauranthandler.dart';


class FavoriteRestaurant extends StatefulWidget {
  const FavoriteRestaurant({super.key});

  @override
  State<FavoriteRestaurant> createState() => _FavoriteRestaurantState();
}

class _FavoriteRestaurantState extends State<FavoriteRestaurant> {
  late TextEditingController keywordController;
  late String keyword;
  Restauranthandler restauranthandler = Restauranthandler();
  @override
  void initState() {
    super.initState();
    keyword = '';
    keywordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          '즐겨 찾기',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: FutureBuilder(
        future: restauranthandler.get
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isEmpty
            ? const Center(
              child: Text('즐겨찾기 한 가게가 없습니다.'),
            )
            :
            Column(
              children: [
                SizedBox(
                  height: 570,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                      '즐겨찾기에서 삭제 하시겠습니까?',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  actions: [
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        handler.deleteFavoriteRestaurant(snapshot.data![index].seq!).then((value) => reloadData(),);
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
                              color: Theme.of(context).colorScheme.onSecondary,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Image.network(
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
                                            padding: const EdgeInsets.fromLTRB(
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

}
