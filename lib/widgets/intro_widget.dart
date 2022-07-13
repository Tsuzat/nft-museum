import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_museum/apis/raribel.dart';
import 'package:nft_museum/pages/collection.dart';
import 'package:nft_museum/screens/webview.dart';
import 'package:nft_museum/utils/default_loading.dart';

class IntroWidget extends StatefulWidget {
  const IntroWidget({Key? key}) : super(key: key);

  @override
  State<IntroWidget> createState() => _IntroWidgetState();
}

class _IntroWidgetState extends State<IntroWidget> {
  List<dynamic> data = [];
  List<ImageProvider> images = [];
  int _currentPage = 0;
  int len = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    data = await RaribleAPI().getSpotlight();
    setImages();
    len = min(15, data.length);
    setState(() {});
  }

  void setImages() {
    for (var i in data) {
      images.add(CachedNetworkImageProvider(i['url']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: images.isEmpty
                      ? Image.asset("assets/images/default.jpg").image
                      : images[_currentPage],
                  fit: BoxFit.cover),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          SizedBox(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                SizedBox(
                  child: Text(
                    "Discover and collect extraodinary NFTs",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      children: const <InlineSpan>[
                        TextSpan(
                          text: "Spotlight.",
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                        TextSpan(
                          text: "Projects you'll love",
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => {
                      data[_currentPage]['islocal']
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowCollection(
                                  address: data[_currentPage]['address'],
                                ),
                              ),
                            )
                          : openBrowserTab(url: data[_currentPage]['address']),
                    },
                    child: images.isEmpty
                        ? Center(
                            child: defaultLoading(),
                          )
                        : FractionallySizedBox(
                            child: PageView.builder(
                              itemCount: len,
                              onPageChanged: (int page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return FractionallySizedBox(
                                  widthFactor: 0.8,
                                  child: Container(
                                    margin: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: images[_currentPage],
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(32),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          data[index]['title'] ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < len; i++)
                        i != _currentPage
                            ? Container(
                                height: 2,
                                width: ((MediaQuery.of(context).size.width) *
                                        0.8) /
                                    (len),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )
                            : Container(
                                height: 2,
                                width: ((MediaQuery.of(context).size.width) *
                                        0.8) /
                                    (len),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
