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
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:image_bg_remover/presentation/main_screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class EditImage extends StatefulWidget {
  final File? imageFile;

  const EditImage({super.key, required this.imageFile});

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  late File? _imageFile;
  bool isProcessing = false;
  File? _processedImage;

  @override
  void initState() {
    super.initState();
    _processedImage = null;
    _imageFile = widget.imageFile;
    print("Picked file path: ${_imageFile?.path}");
    removeBackground();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  @override
  void didUpdateWidget(EditImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.imageFile != oldWidget.imageFile) {
      setState(() {
        _imageFile = widget.imageFile;
        _processedImage = null;
      });
      removeBackground();
    }
  }

  Future<void> removeBackground() async {
    if (_imageFile == null) return;

    setState(() {
      isProcessing = true;
    });
    // replace with your ip address
    final uri = Uri.parse('http://192.168.100.26:5000/remove_bg');
    final request = http.MultipartRequest('POST', uri);

    request.files
        .add(await http.MultipartFile.fromPath('image', _imageFile!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        final processedImage =
            File('${(await getTemporaryDirectory()).path}/processed_image.png');
        await processedImage.writeAsBytes(bytes);

        setState(() {
          _processedImage = processedImage;
          isProcessing = false;
        });
      } else {
        setState(() {
          isProcessing = false;
        });

        print('Error removing background: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isProcessing = false;
      });
      print('Error: $e');
    }
  }

  // Function to download the image and save it to the gallery
  Future<void> downloadImage() async {
    if (_processedImage == null) return;

    if (Platform.isAndroid) {
      PermissionStatus permissionStatus = await Permission.storage.request();
      if (!permissionStatus.isGranted) {
        print("Permission denied");
        return;
      }
    }
    final result = await GallerySaver.saveImage(_processedImage!.path);
    if (result != null && result) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image saved to gallery")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to save image")));
    }
  }

  // Share function
  Future<void> shareImage() async {
    if (_processedImage != null) {
      try {
        await Share.shareXFiles([XFile(_processedImage!.path)],
            text:
                'Check out this image without bg, removed by image bg remover app & developed by AIK!' // Optional text to accompany the image
            );
      } catch (e) {
        print('Error sharing image: $e');
      }
    } else {
      print('No image to share');
    }
  }

  //
  //
  //
  // Banner ADS
  late final BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;
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

  late final InterstitialAd _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  void _loadInterstitialAd() {
    InterstitialAd.load(
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
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  //
  //
  //
  //
  //
  // Main UI Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          // Download BTN
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: InkWell(
              onTap: downloadImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFC400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Share BTN
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: InkWell(
              onTap: () {
                shareImage();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFC400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Delete BTN
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFC400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _imageFile == null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/images/image.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : isProcessing
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFFC400),
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _processedImage == null
                              ? Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  _processedImage!,
                                  fit: BoxFit.cover,
                                ),
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
