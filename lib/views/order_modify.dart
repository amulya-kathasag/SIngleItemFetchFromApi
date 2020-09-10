import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_api/models/order_manipulation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/src/multipart_file.dart';
import 'package:http/src/multipart_file.dart';
import 'package:path/path.dart';

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
  //TextEditingController _imageController = TextEditingController();
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
        //_imageController.text = "https://blackwebapidemo-staticfiles.s3.amazonaws.com/media/minion.png";
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
  String _url;
  int _views;
  int _total_order;
  int _total_revenue;
  String _status;
  File _image;
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

    return RaisedButton(
      child: Text('Upload Image',style: TextStyle(
        color: Colors.black
      ),),

      color: Colors.white,
      onPressed: () async{

        //Dio dio = new Dio();
        var imagePicker = await ImagePicker.pickImage(source: ImageSource.gallery );
        if(imagePicker != null){
          print("not null---------------------------------------------------");
          setState(() {
            _image = imagePicker;
          });
        }
        try{/*
              String filename = _image.path.split('/').last:
        FormData formData = new FormData.fromMap({
          "image":
        await MultipartFile.fromFile(_image.path,filename: filename,
        contentType:new MediaType('image','png')),
        "type": "image/png"
        }) ;
              Response response = await dio.post("path",data: formData,options: Options(
        headers:{
          //"accept":"*/
        //"Content-Type":"multipart/form-data"

       // }
       // ));
          uploadFile() async {
            var postUri = Uri.parse("<APIUrl>");
            var request = new MultipartRequest("POST", postUri);
            request.fields['user'] = 'blah';
            request.files.add(new MultipartFile.fromBytes('file', await File.fromUri("<path/to/file").readAsBytes(), contentType: new MediaType('image', 'jpeg')))
            request.send().then((response) {
              if (response.statusCode == 200) print("Uploaded!");
            });
          }

        }
        catch(e){
            print(e);
        }


      },
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar( title: Text(isEditing ?'Edit Product' : 'Create Product'),),
      body:
      Container(
        padding: const EdgeInsets.all(24),
        child: Form(
        child: SingleChildScrollView(


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
                _buildStatus(),
                SizedBox(height: 15),
                RaisedButton(
                  child: Text('Post', style: TextStyle(
                    color: Colors.white,
                  ),),
                  onPressed: ()async{
                    if(isEditing){

                      final order = OrderManipulation(
                          id: int.parse(_idController.text),
                          name: _nameController.text,
                          price: double.parse(_priceController.text),
                          description: _descriptionController.text,
                          url: _urlController.text,
                          views: int.parse(_viewsController.text),
                          total_order:int.parse(_orderController.text) ,
                          total_revenue: int.parse(_revenueController.text),
                          status: _statusController.text,


                      );
                      final result = await orderService.updateOrder(widget.orderId, order);

                      final title = 'Done';
                      final text = result.error ? (result.errorMessage ?? 'An error occured'): 'Your product is updated';

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
                    else{
                      final order = OrderManipulation(
                        id: int.parse(_idController.text),
                        name: _nameController.text,
                        price: double.parse(_priceController.text),
                        description: _descriptionController.text,
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
