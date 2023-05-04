import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home.dart';

import 'dashboard/dashboard.dart';
import 'fireduinos/fireduinos.dart';

class HomePage extends StatelessWidget {
  const HomePage({ super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return PageView(
      controller: homeController.pageController,
      onPageChanged: (value) {
        homeController.pageIndex.value = value;
      },
      children: const [
        DashboardPage(),
        FireduinosPage(),
      ],
    );
  }
}