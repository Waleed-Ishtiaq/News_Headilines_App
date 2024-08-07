// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_model.dart';
import 'package:news_app/view/home_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = 'General';

  List<String> categoryList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final Width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 26, // Change this to your desired color
        ),
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: height * .02,
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        categoryName = categoryList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                              color: categoryName == categoryList[index]
                                  ? Colors.grey
                                  : Colors.red[300],
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(
                              child: Text(
                                categoryList[index].toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.categoriesNewsApi(categoryName),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  height: height * .18,
                                  width: Width * .3,
                                  imageUrl: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    child: spinkit2,
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                height: height * .18,
                                padding: EdgeInsets.only(left: 15),
                                child: Column(
                                  children: [
                                    Text(
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      snapshot.data!.articles![index].title
                                          .toString(),
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          overflow: TextOverflow.ellipsis,
                                          format.format(dateTime),
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
