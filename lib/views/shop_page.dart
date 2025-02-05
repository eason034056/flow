import 'package:flutter/material.dart';
import 'package:flow/models/product_model.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 這裡之後會從controller獲取商品列表
    final List<ProductModel> products = [
      ProductModel(
        id: '1',
        name: '限定水瓶',
        description: '精美設計的限定版水瓶',
        price: 100,
        imageUrl: 'https://i.pinimg.com/736x/05/7d/cb/057dcb84f3617a5013fb236df83b7848.jpg',
        category: 'bottle',
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '2',
        name: '智能水杯',
        description: '可追蹤飲水量的智能水杯',
        price: 300,
        imageUrl: 'https://i.pinimg.com/736x/91/73/fa/9173fa8e90f5d7d2c8b80964b0e39cd2.jpg',
        category: 'cup',
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '3',
        name: '運動水壺',
        description: '適合運動時使用的輕便水壺',
        price: 150,
        imageUrl: 'https://i.pinimg.com/736x/f7/11/0f/f7110fe047dd1561b892b7ba7a5422f3.jpg',
        category: 'bottle',
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '4',
        name: '保溫杯',
        description: '24小時保溫保冷的不鏽鋼保溫杯',
        price: 200,
        imageUrl: 'https://i.pinimg.com/736x/12/81/40/1281406f6e36c3f4223e1dcf9e294467.jpg',
        category: 'cup',
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '5',
        name: '濾水壺',
        description: '內建濾心的淨水壺',
        price: 250,
        imageUrl: 'https://i.pinimg.com/736x/a4/b9/2b/a4b92bdcefdfe77773d815c7ca67f8d9.jpg',
        category: 'pitcher',
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    return Column(
      children: [
        // 商品列表
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 商品圖片
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          color: Colors.grey[200],
                          image: DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // 商品資訊
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.monetization_on,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${product.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // 購買邏輯
                                },
                                child: const Text('購買'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
