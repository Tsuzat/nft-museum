import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_museum/pages/collection.dart';
import 'package:nft_museum/utils/default_loading.dart';
import 'package:nft_museum/utils/media_api.dart';

class RenderCollectionList extends StatefulWidget {
  final dynamic data;
  final int renderUpto;
  const RenderCollectionList(
      {Key? key, required this.data, required this.renderUpto})
      : super(key: key);

  @override
  State<RenderCollectionList> createState() => _RenderCollectionListState();
}

class _RenderCollectionListState extends State<RenderCollectionList> {
  @override
  @override
  Widget build(BuildContext context) {
    return widget.data.isEmpty
        ? Center(
            child: Text(
              "Nothing to Show",
              style: GoogleFonts.inter(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              String title = widget.data[index]['name'].isNotEmpty
                  ? widget.data[index]['name']
                  : "Unknown";

              String subtitle = widget.data[index]['statistics']
                      .containsKey('floorPrice')
                  ? "Floor: ${num.parse((widget.data[index]['statistics']['floorPrice']['value']).toStringAsFixed(2))} ${widget.data[index]['statistics']['floorPrice']['currency']}"
                  : "Floor: -";

              String trailingAmount;
              if (widget.data[index]['statistics'].containsKey('amount')) {
                num value = widget.data[index]['statistics']['amount']['value'];
                bool isK = value >= 1000;
                value = isK ? value / 1000 : value;
                trailingAmount =
                    "${value.toStringAsFixed(1)}${isK ? 'K' : ''} ${widget.data[index]['statistics']['amount']['currency']}";
              } else {
                trailingAmount = "--";
              }
              String trailingUsdAmount;
              if (widget.data[index]['statistics'].containsKey('usdAmount')) {
                num value =
                    widget.data[index]['statistics']['usdAmount']['value'];
                bool isK = value >= 1000;
                bool isM = value >= 1000000;
                String km =
                    ''; // stores the if it's thousands or milions (K || M)
                if (isM) {
                  km = 'M';
                  value /= 1000000;
                } else if (isK) {
                  km = 'K';
                  value /= 1000;
                }

                trailingUsdAmount = "\$${value.toStringAsFixed(2)}$km ";
              } else {
                trailingUsdAmount = "--";
              }

              num changePercentage =
                  widget.data[index]['statistics'].containsKey('usdAmount') && widget.data[index]['statistics']['usdAmount'].containsKey('changePercent')
                      ? widget.data[index]['statistics']['usdAmount']
                          ['changePercent']
                      : 0;

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowCollection(
                        address: widget.data[index]['id'],
                      ),
                    ),
                  );
                },
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FutureBuilder(
                      future:
                          getThumbnailUrlByAddress(widget.data[index]['id']),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: defaultLoading(),
                            );
                          default:
                            {
                              if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: defaultError(),
                                );
                              } else {
                                // print(snapshot.data);
                                return Image.network(
                                  snapshot.data.toString(),
                                  errorBuilder: ((context, error, stackTrace) =>
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: defaultError(),
                                      )),
                                  fit: BoxFit.cover,
                                );
                              }
                            }
                        }
                      },
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      trailingAmount,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text.rich(
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        text: trailingUsdAmount, // default text style
                        children: <TextSpan>[
                          TextSpan(
                            text: '${changePercentage.toStringAsFixed(2)}%',
                            style: TextStyle(
                                color: changePercentage >= 0
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // trailing: ,
              );
            },
            separatorBuilder: (context, index) {
              return Center(
                child: Container(
                  height: 0.4,
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              );
            },
            itemCount: min(widget.renderUpto, widget.data.length),
          );
  }
}
