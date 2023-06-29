class Product {
  final String name;
  int price;
  int quantity;
  int total_price = 0;

  Product({required this.name, required this.price, required this.quantity}) {
    total_price = price * quantity;
  }
}
