import 'package:dayjour_version_3/helper/store.dart';
import 'package:dayjour_version_3/my_model/my_order.dart';
import 'package:dayjour_version_3/my_model/my_product.dart';
import 'package:get/get.dart';

class CartController extends GetxController{
  // Rx<Order> order=Order(lineItems: <OrderLineItem>[]).obs;
  Rx<String> total="0.00".obs,sub_total="0.00".obs,shipping="15.00".obs;
  var my_order = <MyOrder>[].obs;
  var fake = true.obs;

  //todo save when do any thing

  add_to_cart(MyProduct product , int count){
    for(int i=0;i<my_order.length;i++){
      if(my_order[i].product.value.id==product.id){
        my_order[i].quantity.value = my_order[i].quantity.value + count;
        double x = (my_order[i].quantity.value * double.parse(product.price.toString())) as double;
        my_order[i].price.value = x.toString();
        get_total();
        return ;
      }
    }
    double x = (count * double.parse(product.price.toString())) as double;
    MyOrder myOrder = MyOrder(product:product.obs,quantity:count.obs,price:x.toString().obs);
    my_order.add(myOrder);
    get_total();
  }

  clear_cart(){
    my_order.clear();
    get_total();
  }

  increase(MyOrder myOrder,index){
    my_order[index].quantity.value++;
    double x =  (my_order[index].quantity.value * double.parse(my_order[index].product.value.price.toString())) as double;
    my_order[index].price.value=x.toString();
    get_total();
  }

  decrease(MyOrder myOrder,index){
    if(my_order[index].quantity.value>1){
      my_order[index].quantity.value--;
      double x =  (my_order[index].quantity.value *double.parse(my_order[index].product.value.price.toString())) as double;
      my_order[index].price.value=x.toString();
      get_total();
    }else{
      remove_from_cart(myOrder);
    }

  }
  remove_from_cart(MyOrder myOrder){
    my_order.removeAt(my_order.indexOf(myOrder));
    get_total();
  }

  get_total(){
    double x=0,y=0;
      for (var elm in my_order) {
        x += double.parse(elm.price.value);
        // y += double.parse(elm.shipping.value);
      }
      sub_total.value=x.toString();
      // shipping.value = y.toString();
      total.value = (x + y).toString();
      Store.save_order(my_order.value);
  }
}