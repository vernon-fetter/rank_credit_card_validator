class CreditCard {
  final String cardNumber;
  final String cardType;
  final String cvv;
  final String issuingCountry;
  final DateTime dateAdded;

  CreditCard({
    required this.cardNumber,
    required this.cardType,
    required this.cvv,
    required this.issuingCountry,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
        'cardNumber': cardNumber,
        'cardType': cardType,
        'cvv': cvv,
        'issuingCountry': issuingCountry,
        'dateAdded': dateAdded.toIso8601String(),
      };

  static CreditCard fromJson(Map<String, dynamic> json) {
    return CreditCard(
      cardNumber: json['cardNumber'],
      cardType: json['cardType'],
      cvv: json['cvv'],
      issuingCountry: json['issuingCountry'],
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }
}
