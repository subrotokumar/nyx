import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nyx/pages/nft_screen.dart';
import 'package:nyx/services/cred.dart';
import 'package:shimmer/shimmer.dart';
import 'package:universal_image/universal_image.dart';
import 'package:lottie/lottie.dart';

import '../services/nft_modal.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  bool isVisible = false;

  bool searchCollection = false;

  String name = '';

  Future<List<NFTModel>> fetch(String address) async {
    List<NFTModel> list = [];
    var response = await http.get(Uri.parse(Cred().nftEndpoint(name)));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['ownedNfts'] as List;
      for (var element in data) {
        var i = NFTModel.fromMap(element as Map<String, dynamic>);
        list.add(i);
      }
    }
    return list;
  }

  List<MaterialColor> col = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.brown
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff030c1a),
                  Color(0xff0b1b2b),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 3),
                          InkWell(
                            onTap: () {
                              // setState(() => searchCollection = !searchCollection);
                            },
                            child: Text(
                              !searchCollection
                                  ? 'Explore\nNFTs From Address'
                                  : 'Explore\nCollections',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () async {
                              await fetch(name);
                              setState(() {});
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: Colors.white38,
                                    width: 2,
                                  )),
                              color: Colors.white12,
                              child: const SizedBox(
                                height: 55,
                                width: 45,
                                child: Icon(
                                  Icons.search,
                                  size: 25,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Visibility(
                        visible: true,
                        child: TextField(
                          onChanged: (value) {
                            name = value;
                          },
                          onSubmitted: (value) async {
                            name = value;
                            await fetch(value);
                            setState(() {});
                          },
                          controller: controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'Search . . .',
                            suffixIcon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder<List<NFTModel>>(
                    future: fetch(name),
                    builder: (context, snapshot) {
                      if (name.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LottieBuilder.asset(
                              'assets/lotties/nft-monkey.json',
                              width: double.infinity,
                              height: 200,
                            ),
                          ],
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xff0b1b2b),
                            highlightColor: Colors.grey,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width - 50,
                              height: MediaQuery.of(context).size.width - 50,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return !snapshot.hasData
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LottieBuilder.asset(
                                    'assets/lotties/nft-monkey.json',
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ],
                              )
                            : Swiper(
                                itemHeight:
                                    MediaQuery.of(context).size.width + 90,
                                itemWidth: MediaQuery.of(context).size.width,
                                layout: SwiperLayout.TINDER,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data![index];

                                  String name = data.title.isNotEmpty
                                      ? data.title
                                      : data.contractName;
                                  name = name.length > 30
                                      ? name.substring(0, 30)
                                      : name;
                                  return InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NFTScreen(data),
                                        )),
                                    child: Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.width +
                                                700,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              color: col[index % 7]
                                                  .withOpacity(0.6),
                                              width: 5),
                                          color: col[index % 7].withOpacity(1),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              child: Hero(
                                                tag: 'NFT',
                                                child: UniversalImage(
                                                  data.mediaGateWay,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      Shimmer.fromColors(
                                                    baseColor: col[index % 7]
                                                        .withOpacity(0.3),
                                                    highlightColor:
                                                        col[index % 7]
                                                            .withOpacity(0.8),
                                                    child: Container(
                                                      color: col[index % 7]
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  scale: 0.2,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              19),
                                                      side: BorderSide(
                                                          color: col[index % 7]
                                                              .withOpacity(
                                                                  0.4)),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 19,
                                                      backgroundColor:
                                                          col[index % 7]
                                                              .withOpacity(0.1),
                                                      child: Image.asset(
                                                        'assets/icons/ic_ethereum.png',
                                                        height: 30,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    children: [
                                                      const Spacer(),
                                                      Text(
                                                        name,
                                                        style: const TextStyle(
                                                          shadows: [
                                                            Shadow(
                                                                color: Colors
                                                                    .black,
                                                                blurRadius: 5)
                                                          ],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5)
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5)
                                                  // Text(data.address),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data!.length,
                              );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Hero(
                  tag: 'splash',
                  child: Text(
                    'NYX',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.overline,
                    ),
                  ),
                ),
                const Text(
                  'NFT Galary',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
