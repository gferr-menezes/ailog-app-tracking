import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/application_bind.dart';
import 'app/common/load_dependencies.dart';
import 'app/common/ui/app_ui.dart';
import 'app/routes/home_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    LoadDependencies.execute();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ApplicationBind(),
      debugShowCheckedModeBanner: false,
      theme: AppUI.theme,
      title: 'Ailog Tracking',
      initialRoute: '/home',
      getPages: [
        ...HomeRoutes.routes,
      ],
    );
  }
}
