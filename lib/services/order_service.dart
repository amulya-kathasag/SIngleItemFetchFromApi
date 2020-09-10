import 'dart:convert';

import 'package:flutter_web_api/models/api_response.dart';
import 'package:flutter_web_api/models/order.dart';
import 'package:flutter_web_api/models/order_for_listing.dart';
import 'package:flutter_web_api/models/order_manipulation.dart';
import 'package:http/http.dart' as http;

import '../models/order_for_listing.dart';

class OrderService {

  static const API = "https://l5vqpgr2pd.execute-api.us-west-2.amazonaws.com/dev/api/v1/product";
  static const headers ={
    'Content-type':'application/json'
  };


  Future<APIResponse<List<OrderForListing>>> getOrdersList() async {
    print('Getting order list from API ... *****************');
    return http.get(API+'/')
        .then((data) {
      print( " ${data.statusCode}  ... *****************");
      print('data recieved =  $data');
      if (data.statusCode == 200) { // checking the status code
        final jsonData = json.decode(data.body); // the data returned from API, converting it into a list of objects
        print('data recieved =  $jsonData');
        final orders = <OrderForListing>[];
        for (var item in jsonData) {
          orders.add(OrderForListing.fromJson(item));
          print('------------------------------------------\n $orders  \n---------------------------------------\n');

        }
        return APIResponse<List<OrderForListing>>(data: orders);
      }
      return APIResponse<List<OrderForListing>>(error: true, errorMessage: 'Some error occurred');
    })
    .catchError((_) => APIResponse<List<OrderForListing>>(error: true, errorMessage: 'Some error occurred, caught in catch block'));
  }


  Future<APIResponse<Order>> getOrder(String id) async {
    print('Getting order list from API ... *****************');
    return http.get(API +'/'+ id).then((data) {
      print( " ${data.statusCode}  ... *****************");
      print('data recieved =  $data');
      if (data.statusCode == 200) { // checking the status code
        final jsonData = json.decode(data.body); // the data returned from API, converting it into a list of objects
        print('data recieved =  $jsonData');


          print('------------------------------------------\n $jsonData  \n---------------------------------------\n');

        return APIResponse<Order>(data: Order.fromJson(jsonData));
      }
      return APIResponse<Order>(error: true, errorMessage: 'Some error occurred');
    })
        .catchError((_) => APIResponse<Order>(error: true, errorMessage: 'Some error occurred, caught in catch block'));
  }

  Future<APIResponse<bool>> createOrder(OrderManipulation item) async {
    print('creating  a orderr ... *****************');
    return http.post(API+'/', headers: headers,body: json.encode(item.toJson())).then((data) {
      print( " ${data.statusCode}  ... *****************");
      print("${data.body}...........................");
      if (data.statusCode == 201) { // checking the status code
      print( "${data.statusCode}........................");




        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'Some error occurred');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'Some error occurred, caught in catch block'));
  }

  
  Future<APIResponse<bool>> updateOrder(String id, OrderManipulation item) async {
    print('updating a orderr ... *****************...................');
    return http.put(API+'/'+ id+'/', headers: headers,body: json.encode(item.toJson())).then((data) {
      print( " ${data.statusCode}  ... *****************");
      print("${data.body}...........................");
      if (data.statusCode == 204) { // checking the status code
        print( "${data.statusCode}........................");




        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'Some error occurred');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'Some error occurred, caught in catch block'));
  }

  Future<APIResponse<bool>> deleteOrder(String id) async {
    print('deleting a orderr ... *****************...................');
    return http.delete(API+'/'+ id+'/', headers: headers).then((data) {
      print( " ${data.statusCode}  ... *****************");
      print("${data.body}...........................");
      if (data.statusCode == 204) { // checking the status code
        print( "${data.statusCode}........................");




        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'Some error occurred');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'Some error occurred, caught in catch block'));
  }

}

