import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nft_museum/apis/raribel.dart';
import 'package:nft_museum/pages/owner.dart';
import 'package:nft_museum/utils/default_loading.dart';
import 'package:nft_museum/widgets/render_collection_items.dart';
import 'package:readmore/readmore.dart';

class ShowCollection extends StatefulWidget {
  final String address;
  const ShowCollection({Key? key, required this.address}) : super(key: key);

  @override
  State<ShowCollection> createState() => _ShowCollectionState();
}

class _ShowCollectionState extends State<ShowCollection> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(25, 28, 31, 1),
        body: FutureBuilder(
          future: RaribleAPI().collectionByRawAddress(widget.address),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case (ConnectionState.waiting):
                return Center(child: defaultLoading());
              default:
                {
                  if (snapshot.hasError) {
                    return Center(child: defaultError());
                  } else {
                    return SingleChildScrollView(
                      child: collectionBody(collectionData: snapshot.data),
                    );
                  }
                }
            }
          },
        ),
      ),
    );
  }

  Column collectionBody({required dynamic collectionData}) {
    String posterImageUrl = collectionData['cover'].startsWith("ipfs://")
        ? collectionData['cover'].replaceAll('ipfs://', 'https://ipfs.io/')
        : collectionData['cover'];
    String picUrl = collectionData['pic'].startsWith("ipfs://")
        ? collectionData['pic'].replaceAll('ipfs://', 'https://ipfs.io/')
        : collectionData['pic'];
    String name = collectionData['name'] ?? "Unknown";
    String description = collectionData['description'] ?? "Unknown";
    String owner = collectionData['owner'] ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 220,
          child: Stack(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: CachedNetworkImage(
                  imageUrl: posterImageUrl,
                  placeholder: (context, str) =>
                      Center(child: defaultLoading()),
                  errorWidget: (context, str, dyn) =>
                      Center(child: defaultError()),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                width: 100,
                height: 100,
                top: 120,
                left: 20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(25, 28, 31, 1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 4,
                      color: const Color.fromRGBO(25, 28, 31, 1),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: picUrl,
                      placeholder: (context, str) =>
                          Center(child: defaultLoading(width: 20)),
                      errorWidget: (context, str, dyn) =>
                          Center(child: defaultError(width: 20)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20),
          child: Text(
            name,
            style: GoogleFonts.inder(
              fontSize: 28,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        owner.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Owner(walletAddress: owner),
                      ),
                    );
                  },
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: "Created by ",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(140, 140, 140, 1),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "${owner.substring(0, 6)}...${owner.substring(owner.length - 4, owner.length - 1)}",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 10),
          child: ReadMoreText(
            description,
            colorClickableText: Colors.white,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show More ▼',
            trimExpandedText: '\nShow Less ▲',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color.fromRGBO(255, 255, 255, 0.6),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 180,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(255, 255, 255, 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder(
              future: RaribleAPI().collectionStats(widget.address),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case (ConnectionState.waiting):
                    return Center(
                      child: defaultLoading(),
                    );
                  default:
                    {
                      if (snapshot.hasError) {
                        return Center(
                          child: defaultError(),
                        );
                      } else {
                        dynamic data = snapshot.data;

                        String floor, volume, items, owners, currency;
                        items = modified(data['items']);
                        owners = modified(data['owners']);
                        if (data.containsKey('nativeVolume')) {
                          floor = modified(data['nativeVolume']['floorPrice']);
                          volume = modified(data['nativeVolume']['volume']);
                          currency = data['nativeVolume']['currency'];
                        } else {
                          floor = modified(data['usdVolume']['floorPrice']);
                          volume = modified(data['usdVolume']['volume']);
                          currency = data['usdVolume']['currency'];
                        }
                        return ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            listTile(
                                leading: "Floor", trailing: floor + currency),
                            listTile(
                                leading: "Volume", trailing: volume + currency),
                            listTile(leading: "Items", trailing: items),
                            listTile(leading: "Owners", trailing: owners),
                            // const Divider(
                            //   color: Color.fromRGBO(255, 255, 255, 0.2),
                            //   thickness: 1,
                            // ),
                          ],
                        );
                      }
                    }
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Items",
              style: GoogleFonts.inter(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const RenderCollectionItems(),
      ],
    );
  }
}

Widget listTile({required String leading, required String trailing}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leading,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(255, 255, 255, 0.6),
          ),
        ),
        Text(trailing,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white,
            )),
      ],
    ),
  );
}

String modified(num value) {
  if (value >= 1000000) {
    return "${(value / 1000000).toStringAsFixed(1)}M";
  } else if (value >= 1000) {
    return "${(value / 1000).toStringAsFixed(1)}K";
  }
  return value.toString();
}
