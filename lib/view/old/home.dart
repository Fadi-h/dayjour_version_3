import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dayjour_version_3/app_localization.dart';
import 'package:dayjour_version_3/const/app.dart';
import 'package:dayjour_version_3/const/app_colors.dart';
import 'package:dayjour_version_3/const/drawer.dart';
import 'package:dayjour_version_3/controler/cart_controller.dart';
import 'package:dayjour_version_3/controler/checkout_controller.dart';
import 'package:dayjour_version_3/controler/home_controller.dart';
import 'package:dayjour_version_3/controler/product_controller.dart';
import 'package:dayjour_version_3/controler/wish_list_controller.dart';
import 'package:dayjour_version_3/my_model/category.dart';
import 'package:dayjour_version_3/my_model/top_category.dart';
import 'package:dayjour_version_3/view/cart.dart';
import 'package:dayjour_version_3/view/category_view2.dart';
import 'package:dayjour_version_3/view/profile.dart';
import 'package:dayjour_version_3/view/wishlist.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatelessWidget {

  bool closed = true;
  GlobalKey<ScaffoldState> _key =  GlobalKey<ScaffoldState>();
  final controller = CarouselController();
  final search_controller = TextEditingController();
  HomeController homeController = Get.put(HomeController());
  CartController cartController = Get.put(CartController());
  WishListController wishlistController = Get.put(WishListController());
  CheckoutController checkoutController = Get.put(CheckoutController());



  @override
  Widget build(BuildContext context) {
    return Obx((){
      return  Scaffold(
        backgroundColor: App.main,
        key: _key,
        drawer: DrawerWidget.drawer(context),
        bottomNavigationBar: _btnNavBar(context),
        body:  homeController.selected_bottom_nav_bar.value == 0 ? _home(context) :
          homeController.selected_bottom_nav_bar.value == 1 ? CategoryView2() :
          homeController.selected_bottom_nav_bar.value == 2 ? Wishlist() :
          homeController.selected_bottom_nav_bar.value ==3 ? Cart() : Profile(),

        floatingActionButton:
        GestureDetector(
            onTap: () {
              //todo something
            },
            child: SvgPicture.asset('assets/icons/whatsapp.svg')),
      );
    });
  }

  _best_sellers(BuildContext context){
    return Container(
      color: App.main,
      child: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(App_Localization.of(context).translate("best_sellers"),style: App.textBlod(Colors.black, 20),)
              ],
            ),
            SizedBox(height: 15,),
            Container(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4/6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
              ),
                  shrinkWrap: true,
                  itemCount: homeController.bestSellers.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: (){
                        homeController.go_to_product(homeController.bestSellers[index]);
                      },
                      child: Stack(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))
                              ),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 6,child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(homeController.bestSellers[index].image),
                                      fit: BoxFit.contain
                                    )
                                  ),
                                )),
                                Expanded(flex: 2,child: Padding(
                                  padding: const EdgeInsets.only(left: 5,right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(homeController.bestSellers[index].title,maxLines: 2,overflow: TextOverflow.clip,textAlign: TextAlign.center,style: App.textNormal(Colors.black, 12),),
                                      Text(homeController.bestSellers[index].price.toString()+" "+ App_Localization.of(context).translate("aed"),maxLines: 2,overflow: TextOverflow.clip,textAlign: TextAlign.center,style: App.textNormal(Colors.black, 14),),

                                    ],
                                  ),
                                ))
                              ],
                            )
                          ),
                          Positioned(child: Obx((){
                            return IconButton(
                              icon: Icon(homeController.bestSellers[index].favorite.value?Icons.favorite:Icons.favorite_border,color: App.main2,),
                              onPressed: (){
                                if(homeController.bestSellers[index].favorite.value){
                                  wishlistController.delete_from_wishlist(homeController.bestSellers[index]);
                                }else{
                                  wishlistController.add_to_wishlist(homeController.bestSellers[index]);
                                }

                              },
                            );
                          }))
                        ],
                      ),
                    );
                  })
            ),
          ],
        ),
      ),
    );
  }
  _top_brand(BuildContext context){
    return Container(
      color: App.main,
      child: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(App_Localization.of(context).translate("top_brand"),style: App.textBlod(Colors.black, 20),)
              ],
            ),
            SizedBox(height: 15,),
            Container(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 4/2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
              ),
                  shrinkWrap: true,
                  itemCount: homeController.brands.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: (){
                        homeController.get_products_by_brand(homeController.brands[index].id, context);
                      },
                      child: Container(
                          decoration: BoxDecoration(

                                color: Colors.white,
                                image: DecorationImage(
                                    image: NetworkImage(homeController.brands[index].image.replaceAll("localhost", "10.0.2.2")),
                                    fit: BoxFit.contain
                                )

                              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))
                          ),
                      ),
                    );
                  })
            ),
          ],
        ),
      ),
    );
  }
  _new_arrivals(BuildContext context){
    return Container(
      color: App.main,
      child: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(App_Localization.of(context).translate("new_arrivals"),style: App.textBlod(Colors.black, 20),)
              ],
            ),
            SizedBox(height: 15,),
            Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4/6,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10
                    ),
                    shrinkWrap: true,
                    itemCount: homeController.newArrivals.length,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          homeController.go_to_product(homeController.newArrivals[index]);
                        },
                        child: Stack(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(flex: 6,child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(homeController.newArrivals[index].image),
                                              fit: BoxFit.contain
                                          )
                                      ),
                                    )),
                                    Expanded(flex: 2,child: Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(homeController.newArrivals[index].title,maxLines: 2,overflow: TextOverflow.clip,textAlign: TextAlign.center,style: App.textNormal(Colors.black, 12),),
                                          Text(homeController.newArrivals[index].price.toString()+" "+ App_Localization.of(context).translate("aed"),maxLines: 2,overflow: TextOverflow.clip,textAlign: TextAlign.center,style: App.textNormal(Colors.black, 14),),

                                        ],
                                      ),
                                    ))
                                  ],
                                )
                            ),
                            Positioned(child: Obx((){
                              return IconButton(
                                icon: Icon(homeController.newArrivals[index].favorite.value?Icons.favorite:Icons.favorite_border,color: App.main2,),
                                onPressed: (){
                                  if(homeController.newArrivals[index].favorite.value){
                                    wishlistController.delete_from_wishlist(homeController.newArrivals[index]);
                                  }else{
                                    wishlistController.add_to_wishlist(homeController.newArrivals[index]);
                                  }

                                },
                              );
                            }))
                          ],
                        ),
                      );
                    })
            ),
          ],
        ),
      ),
    );
  }
  _btnNavBar(BuildContext context) {
    return Obx(
          () => Container(
        width: MediaQuery.of(context).size.width,
        child: BottomNavigationBar(
          mouseCursor: SystemMouseCursors.grab,
          unselectedItemColor: AppColors.nav_bar,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 14 , color: AppColors.nav_bar),
          backgroundColor: AppColors.main2,
          iconSize: 25,
          currentIndex: homeController.selected_bottom_nav_bar.value,
          onTap: (index) {
            homeController.selected_bottom_nav_bar.value=index;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: App_Localization.of(context).translate("home"),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(3),
                child: SvgPicture.asset('assets/icons/category.svg',width: 20,height: 20,color: homeController.selected_bottom_nav_bar.value==1?Colors.white:AppColors.nav_bar,
                ),
              ),
              label: App_Localization.of(context).translate("categories"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border,
              ),
              label: App_Localization.of(context).translate("wishlist"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              label: App_Localization.of(context).translate("cart"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              backgroundColor: Colors.white,
              label: App_Localization.of(context).translate("profile"),
            ),
          ],
        ),
      ),
    );
  }
  _home(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _header(context),
                  _body(context),
                  _best_sellers(context),
                  SizedBox(height: 30),
                  _top_brand(context),
                  SizedBox(height: 30),
                  _new_arrivals(context),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Positioned(child: homeController.loading.value?Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppColors.main.withOpacity(0.6),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.main2,),
            ),
          ):Container(
            width: MediaQuery.of(context).size.width,
            height: 0,
            color: AppColors.main,
          ))
        ],
      ),
    );
  }
  _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.24,
      color: AppColors.main2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 12, right: 8, top: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _key.currentState!.openDrawer();
                            },
                            child: Icon(
                              Icons.list,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 25,
                            height: 25,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/introduction/logo.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration:
                            Duration(milliseconds: 300),
                            width: homeController.searchIcon.value ? 40
                                : MediaQuery.of(context).size.width * 0.74,
                            height: 30,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: homeController.searchIcon.value ?
                                    GestureDetector(
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        homeController.searchIcon.value = !homeController.searchIcon.value;
                                      },
                                    ) :
                                    TextField(
                                      controller: search_controller,
                                      style: TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      textAlignVertical:
                                      TextAlignVertical.bottom,
                                      decoration: InputDecoration(
                                        hintText: App_Localization.of(context).translate("search"),
                                        hintStyle: TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          borderSide: BorderSide(color: Colors.white),),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        ),
                                        suffixIcon: GestureDetector(
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,),
                                          onTap: () {
                                            homeController.searchIcon.value = !homeController.searchIcon.value;
                                            search_controller.clear();
                                            // homeController. onclose_category();
                                          },

                                        ),
                                      ),
                                      onSubmitted: (query){
                                        if(query.isNotEmpty){
                                          homeController.get_products_by_search(query, context);
                                          search_controller.text="";
                                          homeController.searchIcon.value = true;
                                        }

                                      },
                                      // onChanged: homeController.search_on_category
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          homeController.category.isEmpty ?
          Container(
            height: MediaQuery.of(context).size.height * 0.18,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  App_Localization.of(context).translate("no_category_with_this_name"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),),
              ],
            ),
          ) :
          Container(
            height: MediaQuery.of(context).size.height * 0.18,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount:
                homeController.category.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      _categories(homeController.category[index], context, index),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
  _categories(Category collection, BuildContext context, int index) {
    return Padding(
        padding: const EdgeInsets.only(left: 8, top: 8),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.21,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  homeController.go_to_sub_category_page(collection.id, context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(collection.image == null
                          ? "https://www.pngkey.com/png/detail/85-853437_professional-makeup-cosmetics.png"
                          : collection.image.toString().replaceAll("localhost", "10.0.2.2")),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Text(
                    collection.title.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
  _body(BuildContext context) {
    return Column(
      children: [
        _slider_images(context),
        SizedBox(height: 15,),
        _top_categories(context),
      ],
    );
  }
  _slider_images(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40)),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                CarouselSlider.builder(
                  carouselController: controller,
                  options: CarouselOptions(
                      height:
                      MediaQuery.of(context).size.height *
                          0.3,
                      autoPlay: homeController
                          .slider.length ==
                          1
                          ? false
                          : true,
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      enlargeStrategy:
                      CenterPageEnlargeStrategy.height,
                      autoPlayInterval: Duration(seconds: 2),
                      onPageChanged: (index, reason) {
                        homeController.selder_selected.value=index;
                        // homeController.set_index(index);
                      }),
                  itemCount: homeController
                      .slider.length,
                  itemBuilder: (BuildContext context,
                      int index, int realIndex) {
                    return GestureDetector(
                      onTap: (){
                        homeController.go_to_product_slider(index);
                      },
                      child: Container(
                        height:
                        MediaQuery.of(context).size.height *
                            0.2,
                        width:
                        MediaQuery.of(context).size.width,
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft:
                                Radius.circular(40)),
                            image: DecorationImage(
                              image: NetworkImage(
                                  homeController.slider[index].image.replaceAll("localhost", "10.0.2.2")),
                              fit: BoxFit.fill,
                            )),
                      ),
                    );
                  },
                ),
                Positioned(
                    left: MediaQuery.of(context).size.width *
                        0.25,
                    bottom: 10,
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width *
                          0.5,
                      child: Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: homeController
                              .selder_selected.value,
                          count: homeController
                              .slider.length,
                          effect: SlideEffect(
                            dotWidth: 10,
                            dotHeight: 10,
                            activeDotColor: AppColors.main2,
                            dotColor: Colors.white,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
  _top_categories(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.62,
      width: MediaQuery.of(context).size.width,
      color: AppColors.main,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child:
          homeController.topCategory.isEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                App_Localization.of(context).translate("no_top_category"),
                style: TextStyle(
                    color: AppColors.main2,
                    fontSize: 35
                ),),
            ],
          )
              :
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 5),
                        child: homeController.topCategory.isEmpty
                            ? Center()
                            : Text(
                            App_Localization.of(context)
                                .translate("top_categories"),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(

                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _top_category_card(homeController.topCategory[0],
                        context, MediaQuery.of(context).size.height * 0.517, 0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _top_category_card(homeController.topCategory[1],
                            context, MediaQuery.of(context).size.height * 0.25, 1),
                        _top_category_card(homeController.topCategory[2],
                            context, MediaQuery.of(context).size.height * 0.25, 2)
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _top_category_card(TopCategory collection, BuildContext context, double height, int index) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          homeController.loading.value = true;
          homeController.go_to_sub_category_page(collection.id, context);
        },
        child: Container(
          height: height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.44,
                    height: height - 40,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(40)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(collection.mainImage == null
                            ? "https://www.pngkey.com/png/detail/85-853437_professional-makeup-cosmetics.png"
                            : collection.mainImage.replaceAll("localhost", "10.0.2.2")),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      collection.category.toString(),
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}

