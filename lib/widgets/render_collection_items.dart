import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_museum/apis/raribel.dart';
import 'package:nft_museum/utils/default_loading.dart';

class RenderCollectionItems extends StatefulWidget {
  final String address;
  final int renderUpto;
  const RenderCollectionItems(
      {Key? key, required this.address, required this.renderUpto})
      : super(key: key);

  @override
  State<RenderCollectionItems> createState() => _RenderCollectionItemsState();
}

class _RenderCollectionItemsState extends State<RenderCollectionItems> {
  List<dynamic> rawData = [];
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    super.initState();
    collectData();
  }

  void collectData() async {
    rawData = await RaribleAPI().getDataOfItemsOfCollection(widget.address, widget.renderUpto);
    for (var d in rawData) {
      Map<String, dynamic> temp = {};
      temp["name"] = d["properties"]["name"] ?? "Unknown";
      temp["price"] = d["ownership"]["price"] ?? "Unknown";
      temp["image"] = d["properties"]["mediaEntries"][1]["url"] ?? "Unknown";
      data.add(temp);
    }
    // print(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? SizedBox(
            height: 500,
            width: double.infinity,
            child: Center(
              child: defaultLoading(),
            ),
          )
        : Center(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 5,
                mainAxisExtent: 250,
              ),
              itemBuilder: (context, index) {
                final item = data[index];
                return Container(
                  //   height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item["image"],
                                fit: BoxFit.cover,
                                errorWidget: (context, str, d) =>
                                    defaultError(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              item['name'],
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children: [
                                Text(
                                  "Price: ${item['price']}",
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.6),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
