import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Represenst a Cart Item. Has <int>`id`, <String>`name`, <int>`quantity`
class CartItem {
  int id;
  String name;
  int quantity;
  CartItem(int theId, String theName, int theQuantity): this.id = theId,this.name = theName, this.quantity = theQuantity ;
  int get numberItem => quantity;
  int get itemId => id;
  void updateQuantity(int value) {
    assert(quantity >= 1);
    num c = quantity - value;
   
    if (value > 0 ){quantity += value;}
    else if( c >= 1){ 
      quantity += value;
    }
  }
  String get nameItem => name;
  
}

/// Manages a cart. Implements ChangeNotifier
class CartState with ChangeNotifier {
  List<CartItem> _products = [];

  CartState();

  /// The number of individual items in the cart. That is, all cart items' quantities.
  int get totalCartItems => _products.fold(0, (total, current) => total + current.numberItem);


   
  
  /// The list of CartItems in the cart
  List<CartItem> get products => _products;

  /// Clears the cart. Notifies any consumers.
  void clearCart() {
    _products.clear();
    notifyListeners();
  }

  /// Adds a new CartItem to the cart. Notifies any consumers.
  void addToCart({required CartItem item}) {
    
    _products.add(item);

    notifyListeners();
  }

  /// Updates the quantity of the Cart item with this id. Notifies any consumers.
  void updateQuantity({required int id, required int newQty}) {
    
    for(int j = 0; j < _products.length; j++ ){
      if(_products[j].itemId == id){
       
       if(_products[j].quantity==1 && newQty<0) _products.remove(_products[j]);
       else {_products[j].updateQuantity(newQty);}
      
        
      }
    }
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartState(),
      child: MyCartApp(),
    ),
  );
}

class MyCartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
      
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500,color:Colors.black,),
          bodyText2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500,color:Colors.black,),
        ),
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          
          child: Column(
            children: [
              CartSummary(),
              CartControls(),
              ListOfCartItems(),
            ],
          ),
        ),
      ),
    );
  }
}

class CartControls extends StatelessWidget {
  

  
  void _addItemPressed(BuildContext context) {
   
    int nextCartItemId = Random().nextInt(10000);
    String nextCartItemName = 'A cart item';
    int nextCartItemQuantity = 1;

    CartItem item = new CartItem(nextCartItemId, nextCartItemName, nextCartItemQuantity) ; 
        
    final cartState = Provider.of<CartState>(context,listen: false);
    cartState.addToCart(item:item);

    
  }

  
  void _clearCartPressed(BuildContext context) {
    final cartState = Provider.of<CartState>(context,listen: false);
    cartState.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    final Widget addCartItemWidget = TextButton(
     
      child: Text('Add Item'),
      onPressed: () {
        _addItemPressed(context);
      },
    );

    final Widget clearCartWidget = TextButton(
     
      child: Text('Clear Cart'),
      onPressed: () {
        _clearCartPressed(context);
      },
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        addCartItemWidget,
        clearCartWidget,
      ],
    );
  }
}

class ListOfCartItems extends StatelessWidget {

  void _incrementQuantity(context, int id, int delta) {
    final cartState = Provider.of<CartState>(context,listen: false);
    cartState.updateQuantity(id:id,newQty:delta);
    
  }

  
  void _decrementQuantity(context, int id, int delta) {
    final cartState = Provider.of<CartState>(context,listen: false);
    cartState.updateQuantity(id:id,newQty:-delta);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartState>(
        builder: (BuildContext context, CartState cart, Widget? child) {
      if (cart.totalCartItems == 0) {
        
        return Center(child:Text("Nothing in cart",
                style: Theme.of(context).textTheme.headline6,
              ),);
      }

      return Column(children: [
        ...cart.products.map(
          (c) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height:120,
              width: MediaQuery.of(context).size.width*0.5,
              child:Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation:0.0,
              child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
               
              Padding(padding:EdgeInsets.only(left:8.0),child:Container(child:Text('${c.name}',style: Theme.of(context).textTheme.bodyText2,
              ),)),
              Container(
          
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[

                IconButton(icon: Icon(Icons.add),color: Theme.of(context).primaryColor, onPressed: (){
                _incrementQuantity(context, c.id, 1);
                
              },splashRadius: 15),
              Container(child:Text('${c.quantity}',style: Theme.of(context).textTheme.bodyText2)),
              IconButton(icon: Icon(Icons.remove),color: Theme.of(context).primaryColor, onPressed: (){
                _decrementQuantity(context, c.id, 1);

              },splashRadius: 15),
              ]))
              ],
            ),
            )
            )
          ),
        ),
      ]);
    });
  }
}

class CartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartState>(
      builder: (BuildContext context, CartState cart, Widget? child) {
        
        return Text("Total items: ${cart.totalCartItems}",style: Theme.of(context).textTheme.bodyText2,);
      },
    );
  }
}
