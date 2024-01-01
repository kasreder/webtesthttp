import 'package:flutter/material.dart';
// import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:refltter/provider/noticeModel.dart';
import 'package:refltter/route.dart';
import 'package:provider/provider.dart';

void main() {
  // turn off the # in the URLs on the web111
  setPathUrlStrategy();
  // usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoticeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:
            ColorService.createMaterialColor(const Color(0xffD8BFD8)),
        fontFamily: "Nanum",
        // fontFamily: "Blackadder ITC",
        // fontFamily: "Arial Rounded MT Bold",
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 15),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 20),
          bodySmall: TextStyle(color: Colors.black, fontSize: 10),
          //title 본문
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          titleMedium: TextStyle(
            color: Colors.black,
            fontSize: 13,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
          //label 메뉴
          labelLarge: TextStyle(
              color: Colors.green, fontSize: 27, fontWeight: FontWeight.w500),
          labelMedium: TextStyle(
              color: Colors.green, fontSize: 22, fontWeight: FontWeight.w500),
          labelSmall: TextStyle(
              color: Colors.green, fontSize: 17, fontWeight: FontWeight.w500),
          headlineLarge: TextStyle(
              color: Colors.blue, fontSize: 40, fontWeight: FontWeight.w500),
          headlineMedium: TextStyle(
              color: Colors.blue, fontSize: 30, fontWeight: FontWeight.w500),
          headlineSmall: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w500),
          displayLarge: TextStyle(
              color: Colors.black, fontSize: 40, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w700),
          displaySmall: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class ColorService {
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

///Thema.of
///1.notosans
///2.에스코어드림
///3.AND가지런한 (유료 ㅜㅜ)
///4.휘갈귀는 폰트(장문X)
///5.길쭉동글 스웨거(영어가능) 두께조절 안됨
///6.옴니고딕 (1:1비율)
///
///      테마 재정의
///     theme: ThemeData(
///     	...
///         textTheme: const TextTheme(
///             headline3: TextStyle(
///                 fontSize: 20,
///                 fontWeight: FontWeight.w500,
///                 fontStyle: FontStyle.italic))),}
///
///    기존 형식은 그대로 copywith만 적용
///Text(
///   "헤드라인3이 적용된 텍스트입니다.",
///   style: Theme.of(context)
///       .textTheme
///       .headline3!
///       .copyWith(color: Theme.of(context).colorScheme.primary),
/// )
///
///  일반사용법
/// Text("헤드라인3이 적용된 텍스트입니다.",
///      style: Theme.of(context).textTheme.headline3,),
///
///  Theme.of(context).copyWith(accentColor: Colors.yellow)
///
///  Text(style: Theme.of(context).textTheme.title,),
/// 배달의민족 을지로체, 삼립호빵체
