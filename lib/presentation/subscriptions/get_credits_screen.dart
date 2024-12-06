//
//
//
//            Develope By :) Athar Ibrahim Khalid
//
//            Published By :) Athar Ibrahim Khalid
//
//            See More Work On
//                -> Github: https://github.com/AtharIbrahim
//                -> Linkedin: https://www.linkedin.com/in/athar-ibrahim-khalid-0715172a2/
//                -> Dribbble: https://dribbble.com/AtharIbrahim
//
//  -This is the modern Image BG Remover App
//
//
//
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetCreditsScreen extends StatefulWidget {
  const GetCreditsScreen({super.key});

  @override
  State<GetCreditsScreen> createState() => _GetCreditsScreenState();
}

class _GetCreditsScreenState extends State<GetCreditsScreen> {
  final StreamController<int> _selected = StreamController<int>();
  int reward = 0;
  List<int> items = [20, 13, 7, 2, 26, 1, 9, 19];
  List<Color> wheelColors = [
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.cyan,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
  ];
  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _selected.close();
    _bannerAd.dispose();

    super.dispose();
  }

  // Wheel Spinner
  void _spinWheel() {
    _showInterstitialAd();

    Future.delayed(const Duration(seconds: 3), () {
      final selectedIndex = Fortune.randomInt(0, items.length);
      _selected.add(selectedIndex);

      Future.delayed(const Duration(seconds: 8), () {
        setState(() {
          reward = items[selectedIndex];
        });
        _showResultDialog(reward);
        _updateUserCredits(reward);
      });
    });
  }

  // Update User Credits
  void _updateUserCredits(int reward) {
    SharedPreferences.getInstance().then((prefs) {
      int currentCredits = prefs.getInt('total_credits') ?? 0;
      int updatedCredits = currentCredits + reward;
      prefs.setInt('total_credits', updatedCredits);
    });
  }

  // Wheel Spin Results Dialog
  void _showResultDialog(int reward) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              "Congratulations!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFC400),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You won $reward credits!",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 50,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Ad's
  //
  //
  // Banner ADS
  late final BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;
  // demo ad unit id
  final String adUnitID = "ca-app-pub-3940256099942544/6300978111";
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitID,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Failed to load a banner ad: $error');
        },
      ),
    )..load();
  }

  //
  // InterstitialAd
  late final InterstitialAd _interstitialAd;
  bool _isInterstitialAdLoaded = false;
  void _loadInterstitialAd() {
    InterstitialAd.load(
      // demo ad unit id
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          setState(() {
            _isInterstitialAdLoaded = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdLoaded) {
      _interstitialAd.show().then((value) {
        _loadInterstitialAd();
      }).catchError((error) {
        print('Error showing interstitial ad: $error');
        _loadInterstitialAd();
      });
    } else {
      print('Interstitial ad not loaded yet');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mobile top context color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(0, 255, 196, 0),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 0),
                const Text(
                  'Spin the Wheel',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFC400),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'and earn credits',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFC400),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(
                      top: -40,
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.pink,
                        size: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color.fromRGBO(255, 196, 0, 1),
                              Color.fromRGBO(255, 196, 0, 1),
                              Color.fromRGBO(255, 196, 0, 1),
                            ],
                            center: const Alignment(-0.2, -0.2),
                            focal: const Alignment(-0.4, -0.4),
                            focalRadius: 0.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: FortuneWheel(
                          selected: _selected.stream,
                          animateFirst: false,
                          duration: const Duration(seconds: 8),
                          rotationCount: 100,
                          items: [
                            for (int i = 0; i < items.length; i++)
                              FortuneItem(
                                style: FortuneItemStyle(
                                  color: wheelColors[i % wheelColors.length],
                                  borderColor: Colors.white,
                                  borderWidth: 5,
                                ),
                                child: Center(
                                  child: Text(
                                    items[i].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: _spinWheel,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 196, 0, 1),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.restart_alt_rounded,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 16,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(145, 203, 203, 203),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _isBannerAdLoaded
                ? Container(
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
