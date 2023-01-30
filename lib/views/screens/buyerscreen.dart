import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import '../../models/homestay.dart';
import '../../models/user.dart';
import '../../serverconfig.dart';
import 'buyerdetailscreen.dart';
import 'loginscreen.dart';
import 'ownerscreen.dart';
import 'profilescreen.dart';
import 'package:http/http.dart' as http;

import 'searchhomestayscreen.dart';

// Buyer screen for the Homestay Raya application
class BuyerScreen extends StatefulWidget {
  final User user;
  const BuyerScreen({super.key, required this.user});

  @override
  State<BuyerScreen> createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  Random random = Random();
  var val = 50; // for load pro pic if updated
  List<Homestay> homestayList = <Homestay>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  var seller;
  //for pagination
  var color;
  var numofpage, curpage = 1;
  int numberofresult = 0;

  @override
  void initState() {
    super.initState();
    // load profile picture if updated
    val = random.nextInt(1000);
    //pagination
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadHomestays(1);
    });
  }

  @override
  void dispose() {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homestay Raya"),
        actions: [
          searchButton(),
          verifyLogin(),
        ],
      ),
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
                    "Homestays ($numberofresult found)",
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
                            _showDetails(index);
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
                                      Text(
                                        truncateString(
                                            "${homestayList[index].homestayLocal}, ${homestayList[index].homestayState}"
                                                .toString(),
                                            15),
                                      ),
                                    ],
                                  ),
                                ))
                          ]),
                        ),
                      );
                    }),
                  ),
                ),
                //pagination widget
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.indigoAccent;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                          onPressed: () => {_loadHomestays(index + 1)},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ));
                    },
                  ),
                ),
              ],
            ),
    );
  }

// method that verify user login status. If no, icon top right will prompt login. If yes, icon top right can let user perform more actions.
  Widget verifyLogin() {
    if (widget.user.id.toString() == "0" &&
        widget.user.email.toString() == "unregistered") {
      return IconButton(
          onPressed: _loginButton, icon: const Icon(Icons.account_circle));
    } else if (widget.user.image.toString() == "no") {
      return PopupMenuButton<int>(
        icon: const Icon(Icons.account_circle),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 1,
            child: Text('Profile'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('My Homestay'),
          ),
          const PopupMenuItem(
            value: 3,
            child: Text('Logout'),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => ProfileScreen(user: widget.user)));
          } else if (value == 2) {
            if (widget.user.verify.toString() == "no") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: const Text(
                      "Verify Account",
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      "You need to verify your account to become an owner",
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          child: const Text(
                            "Okay",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => OwnerScreen(user: widget.user)));
            }
          } else if (value == 3) {
            _logoutUser();
          }
        },
      );
    } else {
      return PopupMenuButton<int>(
        icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                        "${ServerConfig.server}/assets/profileimages/${widget.user.id}.png?v=$val"),
                    fit: BoxFit.cover))),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 1,
            child: Text('Profile'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('My Homestay'),
          ),
          const PopupMenuItem(
            value: 3,
            child: Text('Logout'),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => ProfileScreen(user: widget.user)));
          } else if (value == 2) {
            if (widget.user.verify.toString() == "no") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: const Text(
                      "Verify Account",
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      "You need to verify your account to become an owner",
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      Center(
                        child: TextButton(
                          child: const Text(
                            "Okay",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => OwnerScreen(user: widget.user)));
            }
          } else if (value == 3) {
            _logoutUser();
          }
        },
      );
    }
  }

// search button widget
  Widget searchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => SearchHomestayScreen(user: widget.user)));
      },
    );
  }

  // login method to let user go to login screen
  void _loginButton() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  // Method that let user to log out
  void _logoutUser() {
    User user = User(
        id: "0",
        image: 'no',
        email: "unregistered",
        name: "unregistered",
        address: "na",
        phone: "0123456789",
        verify: "no",
        regdate: "0");
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (content) => BuyerScreen(user: user)));
  }

// method that let user load the homestay list of all owners
  void _loadHomestays(int pageNo) {
    curpage = pageNo;
    numofpage ?? 1;

    http
        .get(
      Uri.parse(
          "${ServerConfig.server}/php/loadallhomestays.php?search=all&pageno=$pageNo"),
    )
        .then((response) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 5,
        message: const Text("Loading..."),
        title: null,
      );
      progressDialog.show();
      print(response.body);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];

          if (extractdata['homestays'] != null) {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata[
                'numberofresult']); //get total number of result returned
            //check if  array object is not null
            homestayList = <Homestay>[]; //complete the array object definition
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
          homestayList.clear();
        }
      } else {
        titlecenter = "No Homestay Available";
        homestayList.clear();
      }
      setState(() {});
      progressDialog.dismiss();
    });
  }

// method to show homestay details
  void _showDetails(int index) async {
    Homestay homestay = Homestay.fromJson(homestayList[index].toJson());
    loadSingleSeller(index);
    //todo update seller object with empty object.
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 5,
      message: const Text("Loading..."),
      title: null,
    );
    progressDialog.show();
    Timer(const Duration(seconds: 1), () {
      if (seller != null) {
        progressDialog.dismiss();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => BuyerDetailScreen(
                      user: widget.user,
                      homestay: homestay,
                      seller: seller,
                    )));
      }
      progressDialog.dismiss();
    });
  }

// method that get the seller information for cartain homestay
  void loadSingleSeller(int index) {
    http.post(Uri.parse("${ServerConfig.server}/php/loadseller.php"),
        body: {"sellerid": homestayList[index].userId}).then((response) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        seller = User.fromJson(jsonResponse['data']);
      }
    });
  }

// method to not let the string over the cards
  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }
}
