class Target {
  final String name;
  double _price; // Harga menjadi private
  double _progress; // Progres menjadi private
  final String imageAsset;

  Target({required this.name, required double price, double progress = 0.0, required this.imageAsset})
      : _price = (price > 0) ? price : 0, // Pastikan harga selalu positif
        _progress = (progress >= 0 && progress <= 1.0) ? progress : 0; // Pastikan progres selalu antara 0 dan 1

  // Getter untuk harga dan progres
  double get price => _price;
  double get progress => _progress;

  // Setter untuk harga dan progres
  set price(double newPrice) {
    if (newPrice >= 0) {
      _price = newPrice;
    }
  }

  set progress(double newProgress) {
    if (newProgress >= 0 && newProgress <= 1.0) {
      _progress = newProgress;
    }
  }

  void addMoney(double amount) {
    if (amount > 0 && this.price > 0) {
      if (amount <= this.price) {
        this.progress += amount / this.price;
        this.price -= amount;
        if (this.progress > 1.0) {
          this.progress = 1.0;
        }
      }
    }
  }
}
