import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nft_museum/apis/raribel.dart';
import 'package:nft_museum/utils/default_loading.dart';
import 'package:nft_museum/widgets/render_collections.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TopCollections extends StatefulWidget {
  const TopCollections({Key? key}) : super(key: key);

  @override
  State<TopCollections> createState() => _TopCollectionsState();
}

class _TopCollectionsState extends State<TopCollections> {
  List<String> options = ["Collection", "Seller"];
  String selectedOption = "Collection";
  List<String> days = ["1 day", "7 days", "30 days"];
  int selectedDay = 0;
  List<String> chains = ["Ethereum", "Tezos", "Flow", "Polygon"];
  String selectedChain = "Ethereum";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      color: const Color.fromRGBO(25, 28, 31, 1),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Top $selectedOption",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton(
                color: const Color.fromRGBO(25, 28, 31, 1),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
                itemBuilder: (context) {
                  return options.map((e) {
                    return PopupMenuItem(
                      value: e,
                      child: Text(
                        e,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList();
                },
                onSelected: (String? newValue) => setState(
                  () {
                    selectedOption = newValue ?? "Collection";
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ToggleSwitch(
                cornerRadius: 20,
                inactiveBgColor: const Color.fromRGBO(255, 255, 255, 0.1),
                animate: true,
                customTextStyles: const [
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 255, 255, 0.6),
                  )
                ],
                animationDuration: 500,
                radiusStyle: true,
                initialLabelIndex: selectedDay,
                totalSwitches: days.length,
                labels: days,
                onToggle: (int? index) {
                  setState(() {
                    selectedDay = index!;
                  });
                },
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedChain,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    dropdownColor: const Color.fromRGBO(25, 28, 31, 1),
                    borderRadius: BorderRadius.circular(15),
                    icon: const Icon(Icons.keyboard_arrow_down_sharp),
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedChain = newValue ?? "Ethereum";
                      });
                    },
                    items: chains
                        .map<DropdownMenuItem<String>>(
                          (String chain) => DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: chain,
                            child: Text(
                              chain,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 360,
            child: RenderCollectionAndSellers(
              option: selectedOption,
              day: days[selectedDay],
              chain: selectedChain,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/search'),
            child: Container(
              width: 190,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "See all collections",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RenderCollectionAndSellers extends StatefulWidget {
  final String option, day, chain;
  const RenderCollectionAndSellers(
      {Key? key, required this.option, required this.day, required this.chain})
      : super(key: key);

  @override
  State<RenderCollectionAndSellers> createState() =>
      _RenderCollectionAndSellersState();
}

class _RenderCollectionAndSellersState
    extends State<RenderCollectionAndSellers> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RaribleAPI().getCollection(
        method: widget.option,
        blockchain: widget.chain,
        period: widget.day,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: defaultLoading(),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                child: Lottie.asset(
                  'assets/json/error.json',
                ),
              );
            } else {
              return widget.option == 'Collection'
                  ? RenderCollectionList(
                      data: snapshot.data,
                      renderUpto: 5,
                    )
                  : const Center(
                      child: Text("To Do"),
                    );
            }
        }
      },
    );
  }
}
