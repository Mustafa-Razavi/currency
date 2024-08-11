import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project_1_currency/Model/Currency.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'dart:ui' as ui;



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // farsi
      ],
      theme: ThemeData(
          fontFamily: 'dana',
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontFamily: 'dana',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w700),
            displayMedium: TextStyle(
                fontFamily: 'dana',
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w300),
            displaySmall: TextStyle(
                fontFamily: 'dana',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w300),
            headlineMedium: TextStyle(
                fontFamily: 'dana',
                fontSize: 14,
                color: Colors.red,
                fontWeight: FontWeight.w700),
            headlineLarge: TextStyle(
                fontFamily: 'dana',
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w700),
          )),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext cntx) async {
    var url =
        'https://sasansafari.com/flutter/api.php?access_key=flutter123456';

    var value = await http.get(Uri.parse(url));

    developer.log(value.body, name: 'getResponse');
    if (currency.isEmpty) {
      if (value.statusCode == 200) {
        _showSnackBar(context, 'بروز رسانی اطلاعات با موفقیت انجام شد');

        List jsonList = convert.jsonDecode(value.body);
        if (jsonList.isNotEmpty) {
          for (int i = 0; i < jsonList.length; i++) {
            setState(() {
              currency.add(Currency(
                  id: jsonList[i]['id'],
                  title: jsonList[i]['title'],
                  price: jsonList[i]['price'],
                  changes: jsonList[i]['changes'],
                  status: jsonList[i]['status']));
            });
          }
        }
      }
    }
    return value;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    developer.log('initState', name: 'wlifecycle');
    getResponse(context);
  }

  @override
  Widget build(BuildContext context) {
    developer.log('build', name: 'wlifecycle');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        elevation: 0, //صفر کردن سایه
        backgroundColor: Colors.white,
        actions: [
          Image.asset('assets/images/icon.png'),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                'قیمت به روز سکه و ارز',
                style: Theme.of(context).textTheme.displayLarge,
              )),
          Expanded(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset('assets/images/menu.png'))),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/Question.png'),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'نرخ ارز آزاد چیست؟ ',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                ' نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.',
                style: Theme.of(context).textTheme.bodyMedium,
                textDirection: ui.TextDirection.rtl,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(1000)),
                    color: Color.fromARGB(255, 130, 130, 130),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'نام آزاد ارز',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'قیمت',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'تغییر',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              //list
              SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/2,
                  child: ListFutureBuilder(context)),
              //update butten box
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/16,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 232, 232),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //update btn
                      SizedBox(
                        height: MediaQuery.of(context).size.height/16,
                        child: TextButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 202, 193, 255)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(1000)))),
                            onPressed: () {
                              currency.clear();
                              ListFutureBuilder(context);
                            },

                            //=> _showSnackBar(
                            //  context, 'بروز رسانی با موفقیت انجام شد'),
                            icon: const Icon(
                              CupertinoIcons.refresh_bold,
                              color: Colors.black,
                            ),
                            label: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Text(
                                'بروز رسانی',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            )),
                      ),

                      Text('آخرین بروز رسانی ${_getTime()}'),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        // ],
      ),
    );
  }

  FutureBuilder<dynamic> ListFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int position) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: MyItem(position, currency),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  if (index % 9 == 0) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Add(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
      future: getResponse(context),
    );
  }

  String _getTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now);
  }
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.displayLarge,
    ),
    backgroundColor: Colors.green,
  ));
}

class MyItem extends StatelessWidget {
  int position;
  List<Currency> currency;

  MyItem(this.position, this.currency);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            currency[position].title!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            getFarsiNumber(currency[position].price.toString()),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            getFarsiNumber(currency[position].changes.toString()),
            style: currency[position].status == 'n'
                ? Theme.of(context).textTheme.headlineMedium
                : Theme.of(context).textTheme.headlineLarge,
          ),
        ],
      ),
    );
  }
}

class Add extends StatelessWidget {
  const Add({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ],
        color: Colors.red,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(
          'تبلیـغات',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ]),
    );
  }
}

String getFarsiNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  en.forEach((element) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });

  return number;
}
