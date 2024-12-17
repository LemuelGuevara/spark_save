import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spark_save/app/home/add_transaction_screen.dart';
import 'package:spark_save/app/home/home_screen.dart';
import 'package:spark_save/app/pooling/split_screen.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppRouterController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Obx(
          () {
            final titles = ['Home', 'Macros', 'Pooling', 'Profile'];
            return Text(
              titles[controller.selectedIndex.value],
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            );
          },
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => controller.screens[controller.selectedIndex.value]),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
          ),
          child: BottomAppBar(
            color: Colors.white,
            elevation: 2,
            shape: const CircularNotchedRectangle(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBottomNavItem(controller.selectedIndex.value, 0,
                      Icons.auto_awesome_mosaic_rounded),
                  _buildBottomNavItem(
                      controller.selectedIndex.value, 1, Icons.auto_awesome),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const AddTransaction(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.green.shade800,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 36),
                    ),
                  ),
                  _buildBottomNavItem(
                      controller.selectedIndex.value, 2, Icons.pie_chart),
                  _buildBottomNavItem(
                      controller.selectedIndex.value, 3, Icons.person_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int currentIndex, int index, IconData icon) {
    return GestureDetector(
      onTap: () => Get.find<AppRouterController>().selectedIndex.value = index,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: currentIndex == index
              ? Colors.green.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 28,
          color: currentIndex == index ? Colors.green.shade800 : Colors.grey,
        ),
      ),
    );
  }
}

class AppRouterController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    Container(color: Colors.purple),
    const SplitScreen(),
    const ProfileScreen(),
  ];
}
