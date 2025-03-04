import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      // Search Bar
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Brand Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    _buildBrandTab('assets/1.PNG',
                        isSelected: true), // Replace with your logo paths
                    _buildBrandTab('assets/1.PNG'),
                    _buildBrandTab('assets/1.PNG'),
                    _buildBrandTab('assets/1.PNG'),
                    _buildBrandTab('assets/1.PNG'),
                  ],
                ),
              ),
            ),

            //SizedBox(height: 10),

            // "Popular" Text and Filter Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Popular',
                    style:
                        TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                IconButton(
                    icon: const Icon(Icons.filter_list), onPressed: () {}),
              ],
            ),

            // SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildShoeCard("title", 250.00, 'assets/nike_shoe1.jpg'),
                  const SizedBox(height: 5),
                  _buildShoeCard('Nike React Miler 2', 280.00, 'assets/1.PNG'),
                  const SizedBox(height: 5),
                  _buildShoeCard("title", 250.00, 'assets/nike_shoe1.jpg'),
                  const SizedBox(height: 5),
                  _buildShoeCard("title", 250.00, 'assets/nike_shoe1.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Set initial selected index
      ),
    );
  }

  Widget _buildBrandTab(String logoPath, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange
              : Colors.grey[300], // Adjust colors as needed
          borderRadius: BorderRadius.circular(7),
        ),
        child: ColorFiltered(
          // Apply grayscale overlay
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.transparent : Colors.grey,
            BlendMode.saturation,
          ),
          child: Image.asset(
            logoPath,
            width: 39, // Adjust logo size
            height: 20,
            color: isSelected ? Colors.white : null, // Tint selected logo
          ),
        ),
      ),
    );
  }

  Widget _buildShoeCard(String title, double price, String imageUrl) {
    return Container(
      // elevation: 1, // Subtle shadow

      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$$price',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.orange),
                  onPressed: () {},
                ),
              ],
            ),

            // SizedBox(height: 10), // Space between price and image

            Center(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.contain,
                height: 70, // Adjust height as needed
                width: double.infinity,
              ),
            ),

            const SizedBox(height: 5), // Space between image and title

            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nike Air Vapormax 2020',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  width: 33,
                  height: 33,
                  //  padding: EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,

                    color: Colors.black, // Circular background
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.grey[200],
                      size: 19,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
