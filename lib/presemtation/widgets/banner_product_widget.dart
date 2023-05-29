import 'package:flutter/material.dart';

class BannerProduct extends StatelessWidget {
  const BannerProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List items = [
          {
            "id": 1,
            "photo":
                "https://i.ibb.co/6NZ8dGk/Holiday-Travel-Agent-Promotion-Banner-Landscape.png",
            "onTap": (item) {},
          },
          {
            "id": 2,
            "photo": "https://i.ibb.co/5xfjdy9/Blue-Modern-Discount-Banner.png",
            "onTap": (item) {},
          },
          {
            "id": 3,
            "photo":
                "https://i.ibb.co/6Rvjyy1/Brown-Yellow-Free-Furniture-Promotion-Banner.png",
            "onTap": (item) {},
          }
        ];

        return SizedBox(
          height: 120.0,
          child: ListView.builder(
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var item = items[index];
              return Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width * 0.7,
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      item["photo"],
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      16.0,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
