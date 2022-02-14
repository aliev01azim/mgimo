import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mgimo_dictionary/controllers/auth_controller.dart';
import 'package:mgimo_dictionary/helpers/purchases_api.dart';
import 'package:path_provider/path_provider.dart';

import 'controllers/main_page_controller.dart';
import 'helpers/scroll_glow.dart';
import 'pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await openHiveBox('main');
  await PurchasesApi.init();
  Get.put<AuthController>(AuthController());
  Get.put<MainScreenController>(MainScreenController());
  runApp(const MyApp());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  if (limit) {
    final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      final File dbFile = File('$dirPath/$boxName.hive');
      final File lockFile = File('$dirPath/$boxName.lock');
      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox(boxName);
      throw 'Failed to open $boxName Box\nError: $error';
    });
    // clear box if it grows large
    if (box.length > 1000) {
      box.clear();
    }
    await Hive.openBox(boxName);
  } else {
    await Hive.openBox(boxName).onError((error, stackTrace) async {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String dirPath = dir.path;
      final File dbFile = File('$dirPath/$boxName.hive');
      final File lockFile = File('$dirPath/$boxName.lock');
      await dbFile.delete();
      await lockFile.delete();
      await Hive.openBox(boxName);
      throw 'Failed to open $boxName Box\nError: $error';
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Словарь МГИМО',
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void checkSession() async {
    // await _controller.logout();
    var box = Hive.box('main');
    if (box.get('user', defaultValue: {}).isEmpty) {
      if (Platform.isAndroid) {
        await _controller.googleSignIn();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hive.box('main').get('user', defaultValue: {}).isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FlutterLogo(
                    size: 100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('Пройдите регистрацию'),
                  GetBuilder<AuthController>(
                    builder: (_) {
                      return TextButton(
                        onPressed: _controller.googleSignIn,
                        child: _.status == UserStatus.Authenticating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Попробовать снова'),
                      );
                    },
                  )
                ],
              ),
            )
          : const MainPage(),
    );
  }
}
