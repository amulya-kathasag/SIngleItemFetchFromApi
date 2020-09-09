import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_api/models/order_manipulation.dart';
import 'package:get_it/get_it.dart';

import '../services/order_service.dart';
import 'package:flutter_web_api/models/order.dart';

class OrderModify extends StatefulWidget {

  final String orderId;
  OrderModify({this.orderId});

  @override
  _OrderModifyState createState() => _OrderModifyState();
}

class _OrderModifyState extends State<OrderModify> {
  bool get isEditing => widget.orderId !=null;

  OrderService get orderService => GetIt.I<OrderService>();

  String errorMessage;
  Order order;

  TextEditingController _idController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  TextEditingController _viewsController = TextEditingController();
  TextEditingController _orderController = TextEditingController();
  TextEditingController _revenueController = TextEditingController();
  TextEditingController _statusController =TextEditingController();

  @override
  void initState() {
    if (isEditing) {
      orderService.getOrder(widget.orderId)
          .then((response) {
        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occured';
        }
        order = response.data;
        _idController.text = order.id.toString();
        _nameController.text = order.name;
        _priceController.text = order.price.toString();
        _descriptionController.text = order.description;
        _imageController.text = "https://blackwebapidemo-staticfiles.s3.amazonaws.com/media/minion.png";
        _urlController.text = order.url;
        _viewsController.text = order.views.toString();
        _orderController.text = order.total_order.toString();
        _revenueController.text = order.total_revenue.toString();
        _statusController.text = order.status;
      });
      super.initState();
    }
  }
  int _id;
  String _name;
  double _price;
  String _description;
  String _image;
  String _url;
  int _views;
  int _total_order;
  int _total_revenue;
  String _status;
  var _statusOptions =['ACTIVE','NOT ACTIVE'];
  var _currentStatusSelected = 'ACTIVE';

  final GlobalKey<_OrderModifyState> _form = GlobalKey<_OrderModifyState>();

  Widget _buildIdField(){

    return TextFormField(
      controller: _idController,
        decoration: InputDecoration(labelText: 'Id'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ]
    );
  }
  Widget _buildNameField(){

    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(labelText: 'Name'),
      keyboardType: TextInputType.text,

    );
  }
  Widget _buildPriceField(){

    return TextFormField(
      controller: _priceController,
        decoration: InputDecoration(labelText: 'Price'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ]
    );
  }
  Widget _buildDescriptionField(){
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(labelText: 'Description'),
      keyboardType: TextInputType.text,

    );
  }
  Widget _buildImageField(){
    return TextFormField(
      controller: _imageController,
      decoration: InputDecoration(labelText: 'Image'),
      keyboardType: TextInputType.text,

    );
  }
  Widget _buildUrlField(){

    return TextFormField(
      controller: _urlController,
      decoration: InputDecoration(labelText: 'Url'),
      keyboardType: TextInputType.url,

    );
  }
  Widget _buildViewsField(){

    return TextFormField(
      controller: _viewsController,
        decoration: InputDecoration(labelText: 'Views'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ]
    );
  }
  Widget _buildOrderField(){
    return TextFormField(
      controller: _orderController,
        decoration: InputDecoration(labelText: 'Total order'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ]
    );
  }
  Widget _buildRevenueField(){

    return TextFormField(
      controller: _revenueController,
        decoration: InputDecoration(labelText: 'Revenue'),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ]
    );

  }
  Widget _buildStatus(){


    return TextFormField(
      controller: _statusController,
      decoration: InputDecoration(labelText: 'Status'),
      keyboardType: TextInputType.text,

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar( title: Text(isEditing ?'Edit Product' : 'Create Product'),),
      body:
      Container(
        padding: const EdgeInsets.all(24),
        child: Form(

          child: Column(

            children: <Widget>[
              _buildIdField(),
              _buildNameField(),
              _buildPriceField(),
              _buildDescriptionField(),
              _buildImageField(),
              _buildUrlField(),
              _buildViewsField(),
              _buildOrderField(),
              _buildRevenueField(),
              SizedBox(height: 5),
              _buildStatus(),
              SizedBox(height: 15),
              RaisedButton(
                child: Text('Post', style: TextStyle(
                  color: Colors.white,
                ),),
                onPressed: ()async{
                  if(isEditing){

                  }
                  else{
                    final order = OrderManipulation(
                      id: int.parse(_idController.text),
                      name: _nameController.text,
                      price: double.parse(_priceController.text),
                      description: _descriptionController.text,
                      image:_imageController.text,
                      url: _urlController.text,
                      views: int.parse(_viewsController.text),
                      total_order:int.parse(_orderController.text) ,
                      total_revenue: int.parse(_revenueController.text),
                      status: _statusController.text

                    );
                    final result = await orderService.createOrder(order);

                    final title = 'Done';
                    final text = result.error ? (result.errorMessage ?? 'An error occured'): 'Your product is created';

                    showDialog(context: context,
                    builder: (_) => AlertDialog(
                      title: Text(title),
                      content: Text(text),
                      actions:<Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        )
                      ]
                    ));
                  }
                },
              )

            ],
          ),
        ),

      )
    );
  }
  void dropDownItemSelected(String newValue){
    setState(() {
      this._currentStatusSelected = newValue;
    });
  }
}
