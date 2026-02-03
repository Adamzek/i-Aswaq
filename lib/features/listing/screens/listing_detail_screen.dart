import 'package:flutter/material.dart';

class Seller {
  final String name;
  final String initial;
  final bool isVerified;

  Seller({required this.name, required this.initial, this.isVerified = false});
}

class Item {
  final String title;
  final double price;
  final String condition;
  final String category;
  final String description;
  final Seller seller;

  Item({
    required this.title,
    required this.price,
    required this.condition,
    required this.category,
    required this.description,
    required this.seller,
  });
}

final dummyItem = Item(
  title: "MacBook Pro 2021 M1 – Like New Condition",
  price: 4500.00,
  condition: "Used",
  category: "Electronics",
  description:
      "Selling my MacBook Pro 2021 with M1 chip. Bought in January 2022, used mainly for studies. Comes with original charger and box. Minor scratches on the bottom, screen is perfect. Battery health at 92%. Perfect for students!",
  seller: Seller(name: "Ahmad Faisal", initial: "A", isVerified: true),
);

class ItemDetailsPage extends StatefulWidget {
  const ItemDetailsPage({Key? key}) : super(key: key);

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  bool _isLiked = false;

  final Color kGoldColor = const Color(0xFFD4AF37);
  final Color kGreyBackground = const Color(0xFFF5F5F5);
  final Color kTextGrey = const Color(0xFF757575);
  final Color kPurpleBackground = const Color(0xFF7B1FA2);

  @override
  Widget build(BuildContext context) {
    final item = dummyItem;

    return Scaffold(
      backgroundColor: kPurpleBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350.0,
                backgroundColor: kPurpleBackground,
                elevation: 0,
                pinned: true,
                stretch: true,
                leadingWidth: 80,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                  child: _buildCircularIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 8.0),
                    child: Row(
                      children: [
                        _buildCircularIconButton(
                          icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                          iconColor: _isLiked ? Colors.red : Colors.black,
                          onTap: () {
                            setState(() {
                              _isLiked = !_isLiked;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isLiked
                                    ? "Added to favorites!"
                                    : "Removed from favorites."),
                                duration: const Duration(milliseconds: 800),
                                backgroundColor: kGoldColor,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 15),

                        _buildCircularIconButton(
                          icon: Icons.share_outlined,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Sharing link copied to clipboard!"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)],
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.laptop_mac,
                          color: Colors.white.withOpacity(0.3), size: 120),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, left: 24.0, right: 24.0, bottom: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  children: [
                                    _buildTag(item.condition),
                                    const SizedBox(width: 10),
                                    _buildTag(item.category),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                Text(
                                  "RM ${item.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: kGoldColor,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                InkWell(
                                  onTap: () {
                                    print("Navigate to seller profile");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                      color: kGreyBackground,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xFFEEDCBA),
                                          radius: 24,
                                          child: Text(
                                            item.seller.initial,
                                            style: TextStyle(
                                              color: kGoldColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    item.seller.name,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  if (item.seller.isVerified) ...[
                                                    const SizedBox(width: 4),
                                                    Icon(Icons.check_circle,
                                                        color: kGoldColor,
                                                        size: 18),
                                                  ]
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "View Profile",
                                                style: TextStyle(
                                                  color: kGoldColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios,
                                            size: 16, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                const Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  item.description,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: kTextGrey,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(height: 300, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Opening chat...")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGoldColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text(
                    "Chat with Seller",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCircularIconButton(
      {required IconData icon,
      required VoidCallback onTap,
      Color iconColor = Colors.black}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
            ]),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kGreyBackground,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: kTextGrey,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
