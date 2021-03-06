import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opolah/models/item.dart';

class Cart {
  String itemID, type, qty, id, userID;
  bool choosed;
  Item item;

  Cart(this.itemID, this.userID, this.type, this.qty, this.item);
  Cart.withId(this.id, this.itemID, this.userID, this.type, this.qty);

  String get getID => id;
  String get getItemID => itemID;
  String get getUserID => userID;
  String get getType => type;
  String get getQuantity => qty;
  Item get getItem => item;
  bool get getChoosed => choosed;

  void setID(String id) {
    this.id = id;
  }

  void setQuantity(String qty) {
    this.qty = qty;
  }

  Map<String, dynamic> _cartToJson(Cart cart) {
    var map = Map<String, dynamic>();
    map['itemID'] = cart.item.getID;
    map['userID'] = cart.getUserID;
    map['type'] = cart.getType;
    map['qty'] = cart.getQuantity;
    map['item'] = cart.getItem.toJson();
    return map;
  }

  Map<String, dynamic> toJson() => _cartToJson(this);

  Cart.fromJson(Map<String, dynamic> map) {
    this.item = Item.fromJson(map['item']);
    this.itemID = map['itemID'];
    this.userID = map['userID'];
    this.type = map['type'];
    this.qty = map['qty'];
    this.choosed = false;
  }

  Cart.fromSnapshot(DocumentSnapshot map) {
    this.id = map.id;
    this.item = Item.fromJson(map.data()['item']);
    this.itemID = map.data()['itemID'];
    this.userID = map.data()['userID'];
    this.type = map.data()['type'];
    this.qty = map.data()['qty'];
    this.choosed = false;
  }
}
