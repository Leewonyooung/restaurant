import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/view/restaurant_location.dart';
import 'package:restaurant/vm/restauranthandler.dart';

class SearchRestaurant extends StatefulWidget {
  const SearchRestaurant({super.key});

  @override
  State<SearchRestaurant> createState() => _SearchRestaurantState();
}

class _SearchRestaurantState extends State<SearchRestaurant> {
  late TextEditingController keywordController;
  late Restauranthandler handler;
  late String keyword;

  @override
  void initState() {
    super.initState();
    keyword = '';
    handler = Restauranthandler();
    keywordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 55,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8,8,0,12),
          child: Row(
            children: [
              SizedBox(
                height: 43,
                width: MediaQuery.of(context).size.width/1.38,
                child: SearchBar(
                  controller: keywordController,
                  onChanged: (value) {
                    keyword = keywordController.text.trim();
                    setState(() {});
                  },
                  trailing: [
                    IconButton(
                      onPressed: () {   
                        keyword = keywordController.text.trim();
                        setState(() {});
                      }, 
                      icon: const Icon(Icons.search)
                    ),
                  ],
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )),
                ),
              ),
              TextButton(
              onPressed: () {
                Get.back();
                keywordController.text='';
                keyword = '';
                setState(() {    
                });
              }, 
              child: Text('취소',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 20,
                ),
              )
            ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: FutureBuilder(
            future: handler.findRestaurantCategory(keyword.trim()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return keyword == ''
                ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('매장을 검색해보세요.'),
                    ],
                  ),
                )
                :
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 600,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
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
                                                Image.network(
                                                  'http://127.0.0.1:8000/image/view/${snapshot.data![index].image}',
                                                  width: 80,
                                                  height: 80,
                                                ),
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
                              );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('저장된 맛집이 없습니다.'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}