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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaidCreditsScreen extends StatefulWidget {
  const PaidCreditsScreen({super.key});

  @override
  State<PaidCreditsScreen> createState() => _PaidCreditsScreenState();
}

class _PaidCreditsScreenState extends State<PaidCreditsScreen> {
  final List<Map<String, dynamic>> offers = [
    {'credits': 100, 'price': 1.99},
    {'credits': 250, 'price': 4.99},
    {'credits': 500, 'price': 8.99},
    {'credits': 1000, 'price': 15.99},
    {'credits': 2000, 'price': 29.99},
    {'credits': 5000, 'price': 49.99},
  ];
  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(0, 255, 196, 0),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Buy Credits",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 66, 16, 16),
            child: Expanded(
              child: GridView.builder(
                itemCount: offers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.6 / 2,
                ),
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return _buildOfferCard(offer['credits'], offer['price']);
                },
              ),
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
        ],
      ),
    );
  }

  // Widget to build an offer card
  Widget _buildOfferCard(int credits, double price) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$credits Credits',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showAlert("Contact To Seller", "WhatsApp : +92 312-3456789");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 196, 0, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Buy',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
