import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class Product {
  final String name;
  final double price;

  Product(this.name, this.price);
}

class MyApp extends StatelessWidget {
  final List<Product> products = [
    Product("Laptop", 55000),
    Product("Mobile", 25000),
    Product("Headphones", 2000),
    Product("Keyboard", 1500),
    Product("Mouse", 800),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product List")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            title: Text(product.name),
            trailing: Text(
              "?${product.price.toStringAsFixed(0)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
