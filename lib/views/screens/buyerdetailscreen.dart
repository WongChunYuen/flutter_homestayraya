import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/homestay.dart';
import '../../models/user.dart';
import '../../serverconfig.dart';

class BuyerDetailScreen extends StatefulWidget {
  final Homestay homestay;
  final User user;
  final User seller;
  const BuyerDetailScreen(
      {super.key,
      required this.homestay,
      required this.user,
      required this.seller});

  @override
  State<BuyerDetailScreen> createState() => _BuyerDetailScreenState();
}

class _BuyerDetailScreenState extends State<BuyerDetailScreen> {
  late double screenHeight, screenWidth, resWidth;
  final List<String> _imageList = [];
  final TextEditingController _sellernameController = TextEditingController();
  final TextEditingController _hsdescController = TextEditingController();
  final TextEditingController _hspriceController = TextEditingController();
  final TextEditingController _hsaddrController = TextEditingController();
  final TextEditingController _hsstateController = TextEditingController();
  final TextEditingController _hslocalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDetails();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 16,
              ),
              Center(
                child: SizedBox(
                  height: 250,
                  child: PageView.builder(
                      itemCount: _imageList.length,
                      controller: PageController(viewportFraction: 0.9),
                      itemBuilder: (BuildContext context, int index) {
                        return Transform.scale(
                          scale: 1,
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(_imageList[index]),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.homestay.homestayName.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextFormField(
                        enabled: false,
                        controller: _hsdescController,
                        decoration: const InputDecoration(
                            labelText: 'Homestay Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        enabled: false,
                        controller: _hspriceController,
                        decoration: const InputDecoration(
                            labelText: 'Homestay Price/days',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.attach_money),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        enabled: false,
                        controller: _hsaddrController,
                        decoration: const InputDecoration(
                            labelText: 'Homestay Address',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.place),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                                enabled: false,
                                controller: _hsstateController,
                                decoration: const InputDecoration(
                                    labelText: 'States',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.flag),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    )))),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              enabled: false,
                              controller: _hslocalController,
                              decoration: const InputDecoration(
                                  labelText: 'Locality',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.map),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        )
                      ],
                    ),
                    TextFormField(
                        enabled: false,
                        controller: _sellernameController,
                        decoration: const InputDecoration(
                            labelText: 'Owner Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                  ]),
                ),
              ),
            ]),
          ),
          _verifyUser(),
        ],
      ),
    );
  }

  Future<void> _loadDetails() async {
    _sellernameController.text = widget.seller.name.toString();
    _hsdescController.text = widget.homestay.homestayDesc.toString();
    _hspriceController.text = widget.homestay.homestayPrice.toString();
    _hsaddrController.text = widget.homestay.homestayAddress.toString();
    _hsstateController.text = widget.homestay.homestayState.toString();
    _hslocalController.text = widget.homestay.homestayLocal.toString();
  }

  Future<void> _loadImages() async {
    int imageLength = int.parse(widget.homestay.homestayImages.toString());

    for (int i = 1; i <= imageLength; i++) {
      String imageUrl =
          "${ServerConfig.server}/assets/homestayimages/${widget.homestay.homestayId}_$i.png";

      _imageList.add(imageUrl);
    }
    setState(() {});
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.seller.phone,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeSmS() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: widget.seller.phone,
    );
    await launchUrl(launchUri);
  }

  openwhatsapp() async {
    var whatsapp = widget.seller.phone;
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp not installed")));
      }
    }
  }

  Future<void> _onRoute() async {
    final Uri launchUri = Uri(
        scheme: 'https',
        // ignore: prefer_interpolation_to_compose_strings
        path: "www.google.com/maps/@" +
            widget.homestay.homestayLat.toString() +
            "," +
            widget.homestay.homestayLng.toString() +
            ",20z");
    await launchUrl(launchUri);
  }

  Widget _verifyUser() {
    if (widget.user.id.toString() == "0" &&
        widget.user.email.toString() == "unregistered") {
      return const Expanded(
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Card(
              child: Text("Please login an account to get more information")),
        ),
      );
    } else {
      return Expanded(
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Card(
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      iconSize: 32,
                      onPressed: _makePhoneCall,
                      icon: const Icon(Icons.call)),
                  IconButton(
                      iconSize: 32,
                      onPressed: _makeSmS,
                      icon: const Icon(Icons.message)),
                  IconButton(
                      iconSize: 32,
                      onPressed: openwhatsapp,
                      icon: const Icon(Icons.whatsapp)),
                  IconButton(
                      iconSize: 32,
                      onPressed: _onRoute,
                      icon: const Icon(Icons.map)),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
