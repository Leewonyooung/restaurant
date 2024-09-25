import 'package:flutter/material.dart';
import 'package:restaurant/view/favorite_restaurant.dart';
import 'package:restaurant/view/restaurant_list.dart';
import 'package:restaurant/view/search_restaurant.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class RestaurantTab extends StatefulWidget {
  const RestaurantTab({super.key});

  @override
  State<RestaurantTab> createState() => _RestaurantTabState();
}

class _RestaurantTabState extends State<RestaurantTab> with SingleTickerProviderStateMixin{
  late TabController controller;  // 탭바 property
  
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3 , vsync: this, animationDuration: Duration.zero); // length : 탭의 개수 (페이지의 개수)
  }

  @override
  void dispose() {
    controller.dispose(); //순서에 주의
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [RestaurantList(), SearchRestaurant(), FavoriteRestaurant(), ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        height: 70,
        child: TabBar(      
          isScrollable: false,
          controller: controller,
          labelPadding: EdgeInsets.zero,
          indicatorColor: Colors.grey,
          indicatorWeight: 3,
          overlayColor: const WidgetStatePropertyAll(Colors.red),
          splashBorderRadius: BorderRadius.circular(20),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: RectangularIndicator(
            verticalPadding: 18,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
            bottomLeftRadius: 20,
            bottomRightRadius: 20,
            topLeftRadius: 20,
            topRightRadius: 20,
          ),
          tabs: const [
            Tab(
              icon: SizedBox(width: 70, child: Icon(Icons.home)),
            ),
            Tab(
              height: 30,
              icon: SizedBox(width: 70, child: Icon(Icons.search_outlined)),
            ),
            Tab(
              icon: SizedBox(width: 70, child: Icon(Icons.star)),
            ),
          ],
        ),
      ),
    );
  }
}