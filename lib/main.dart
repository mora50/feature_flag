import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> list = [];
  int perPageItem = 4;
  late int pageCount;
  int selectedIndex = 0;
  late int lastPageItemLength;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 1.2);
    for (int i = 1; i <= 10; i++) {
      list.add('$i');
    }
    var num = (list.length / perPageItem);
    pageCount = num.isInt ? num.toInt() : num.toInt() + 1;

    var reminder = list.length.remainder(perPageItem);
    lastPageItemLength = reminder == 0 ? perPageItem : reminder;

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 390,
            child: PageView.builder(
                controller: pageController,
                itemCount: pageCount,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                itemBuilder: (_, pageIndex) {
                  return Center(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(46, 40, 10, 0),
                      primary: false,
                      childAspectRatio: 1.1,
                      shrinkWrap: true,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      crossAxisCount: 4,
                      children: List.generate(
                          (pageCount - 1) != pageIndex
                              ? perPageItem
                              : lastPageItemLength, (index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.all(5),
                            color: Colors.amber,
                            alignment: Alignment.center,
                            child: Text(
                              list[index + (pageIndex * perPageItem)],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 15,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: pageCount,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Colors.red
                            .withOpacity(selectedIndex == index ? 1 : 0.5)),
                    margin: const EdgeInsets.all(5),
                    width: 10,
                    height: 10,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension NumExtensions on num {
  bool get isInt => (this % 1) == 0;
}
