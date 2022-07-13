import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RenderCollectionItems extends StatefulWidget {
  const RenderCollectionItems({Key? key}) : super(key: key);

  @override
  State<RenderCollectionItems> createState() => _RenderCollectionItemsState();
}

class _RenderCollectionItemsState extends State<RenderCollectionItems> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dummy = {
      "name": "Dummy",
      "price": 123,
      "maxBid": 456,
      "image": "assets/images/example.webp"
    };
    final List<dynamic> data = [];
    for (int i = 0; i < 12; i++) {
      data.add(dummy);
    }
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        child: Image.asset(
                          item['image'],
                          fit: BoxFit.fill,
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
                              color: const Color.fromRGBO(255, 255, 255, 0.6),
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
