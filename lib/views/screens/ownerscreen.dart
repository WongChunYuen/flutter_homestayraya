import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import '../../serverconfig.dart';
import '../../models/homestay.dart';
import '../../models/user.dart';
import 'buyerscreen.dart';
import 'detailscreen.dart';
import 'newhomestayscreen.dart';

class OwnerScreen extends StatefulWidget {
  final User user;
  const OwnerScreen({super.key, required this.user});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  var _lat, _lng;
  late Position _position;
  List<Homestay> homestayList =
      <Homestay>[]; // array to store homestay in a list
  String titlecenter = "Loading...";
  var placemarks;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

// load all homestay in the beginning
  @override
  void initState() {
    super.initState();
    _loadHomestays();
  }

  @override
  void dispose() {
    homestayList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (content) => BuyerScreen(user: widget.user)));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("My Homestay"), actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("New Homestay"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              _gotoNewHomestay();
            }
          }),
        ]),
        body: homestayList.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Your current homestay (${homestayList.length} found)",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: rowcount,
                      children: List.generate(homestayList.length, (index) {
                        return Card(
                          elevation: 8,
                          child: InkWell(
                            onTap: () {
                              _showhsDetails(index);
                            },
                            onLongPress: () {
                              _deletehsDialog(index);
                            },
                            child: Column(children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  width: resWidth / 2,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${ServerConfig.server}/assets/homestayimages/${homestayList[index].homestayId}_1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          truncateString(
                                              homestayList[index]
                                                  .homestayName
                                                  .toString(),
                                              15),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            "RM ${double.parse(homestayList[index].homestayPrice.toString()).toStringAsFixed(2)}"),
                                        Text(homestayList[index]
                                            .homestayDate
                                            .toString()),
                                      ],
                                    ),
                                  ))
                            ]),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

// method to let user create a new homestay
  Future<void> _gotoNewHomestay() async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      message: const Text("Searching your current location"),
      title: null,
    );
    progressDialog.show();
    if (await _checkPermissionGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewHomestayScreen(
                  position: _position,
                  user: widget.user,
                  placemarks: placemarks)));
      _loadHomestays();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      progressDialog.dismiss();
    }
  }

//check permission,get location,get address return false if any problem.
  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

// load all the homestay for the owner
  void _loadHomestays() {
    http
        .get(
      Uri.parse(
          "${ServerConfig.server}/php/load_homestay.php?userid=${widget.user.id}"),
    )
        .then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data']; //extract data from jsondata array
        if (extractdata['homestays'] != null) {
          homestayList = <Homestay>[];
          extractdata['homestays'].forEach((v) {
            homestayList.add(Homestay.fromJson(v));
          });
          titlecenter = "Found";
        } else {
          titlecenter = "No Homestay Available";
          homestayList.clear();
        }
      } else {
        titlecenter = "No Homestay Available";
        homestayList.clear(); //clear homestayList array
      }
      setState(() {
        DefaultCacheManager manager = DefaultCacheManager();
        manager.emptyCache();
      });
    });
  }

// method navigate to certain homestay
  Future<void> _showhsDetails(int index) async {
    Homestay homestay = Homestay.fromJson(homestayList[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => DetailsScreen(
                  homestay: homestay,
                  user: widget.user,
                )));
    _loadHomestays();
  }

// delete dialog for the homestay
  void _deletehsDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete ${truncateString(homestayList[index].homestayName.toString(), 15)}",
            textAlign: TextAlign.center,
          ),
          content: const Text("Are you sure?", textAlign: TextAlign.center),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text(
                    "Yes",
                    style: TextStyle(),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _deleteHomestay(index);
                  },
                ),
                TextButton(
                  child: const Text(
                    "No",
                    style: TextStyle(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

// method to delete certain homestay
  void _deleteHomestay(index) {
    try {
      http.post(Uri.parse("${ServerConfig.server}/php/delete_homestay.php"),
          body: {
            "homestayid": homestayList[index].homestayId,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadHomestays();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
