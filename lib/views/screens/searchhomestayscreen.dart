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

// Buyer screen for the Homestay Raya application
class SearchHomestayScreen extends StatefulWidget {
  final User user;
  const SearchHomestayScreen({super.key, required this.user});

  @override
  State<SearchHomestayScreen> createState() => _SearchHomestayScreenState();
}

class _SearchHomestayScreenState extends State<SearchHomestayScreen> {
  Random random = Random();
  var val = 50; // for load pro pic if updated
  List<Homestay> homestayList = <Homestay>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "all";
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadHomestays("all", 1);
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
        title: Container(
          color: Colors.white.withOpacity(0.7),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search",
              border: InputBorder.none,
              hintStyle: const TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  search = searchController.text;
                  _loadHomestays(search, 1);
                },
              ),
            ),
          ),
        ),
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
                ),
                //pagination widget
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //build the list for textbutton with scroll
                      if ((curpage - 1) == index) {
                        //set current page number active
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                          onPressed: () => {_loadHomestays(search, index + 1)},
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

  Widget verifyLogin() {
    if (widget.user.id.toString() == "0" &&
        widget.user.email.toString() == "unregistered") {
      return IconButton(
          onPressed: _loginButton, icon: const Icon(Icons.account_circle));
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => OwnerScreen(user: widget.user)));
          } else if (value == 3) {
            null;
          }
        },
      );
    }
  }

  Widget searchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        _loadSearchDialog();
      },
    );
  }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadHomestays(search, 1);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  // login method to let user go to login screen
  void _loginButton() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  void _loadHomestays(String search, int pageNo) {
    curpage = pageNo;
    numofpage ?? 1; //get total num of pages if not by default set to only 1

    http
        .get(
      Uri.parse(
          "${ServerConfig.server}/php/loadallhomestays.php?search=$search&pageno=$pageNo"),
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
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array

          if (extractdata['homestays'] != null) {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata[
                'numberofresult']); //get total number of result returned
            //check if  array object is not null
            homestayList = <Homestay>[]; //complete the array object definition
            extractdata['homestays'].forEach((v) {
              //traverse homestays array list and add to the list object array homestayList
              homestayList.add(Homestay.fromJson(
                  v)); //add each homestay array to the list object array homestayList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "Cannot find this Homestay"; //if no data returned show title center
            homestayList.clear();
          }
        } else {
          titlecenter = "Cannot find this Homestay"; //status code other than 200
          homestayList.clear();
        }
      } else {
        titlecenter = "Cannot find this Homestay"; //status code other than 200
        homestayList.clear(); //clear homestayList array
      }

      setState(() {}); //refresh UI
      progressDialog.dismiss();
    });
  }

  _showDetails(int index) async {
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

  loadSingleSeller(int index) {
    http.post(Uri.parse("${ServerConfig.server}/php/loadseller.php"),
        body: {"sellerid": homestayList[index].userId}).then((response) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        seller = User.fromJson(jsonResponse['data']);
      }
    });
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }
}
