// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/categories_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';
import 'package:news_app/view/categories_Screen.dart';
import 'package:news_app/view/news_detail.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, fortune, reuters, cnn, alJazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  FilterList? selectedMenu;

  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final Width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: 25,
            width: 25,
            color: Colors.white,
          ),
        ),
        title: Center(
          child: Text(
            'Latest News',
            style: GoogleFonts.poppins(
                fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 26,
              ),
              initialValue: selectedMenu,
              onSelected: (FilterList item) {
                setState(
                  () {
                    selectedMenu = item;
                    if (item == FilterList.bbcNews) {
                      name = 'bbc-news';
                    }
                    if (item == FilterList.aryNews) {
                      name = 'ary-news';
                    }
                    if (item == FilterList.alJazeera) {
                      name = 'al-jazeera-english';
                    }
                    if (item == FilterList.cnn) {
                      name = 'cnn';
                    }
                    if (item == FilterList.reuters) {
                      name = 'reuters';
                    }
                    if (item == FilterList.fortune) {
                      name = 'fortune';
                    }
                    // print('selected: $name');
                  },
                );
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<FilterList>>[
                    PopupMenuItem<FilterList>(
                      value: FilterList.bbcNews,
                      child: Text('BBC News'),
                    ),
                    PopupMenuItem<FilterList>(
                      value: FilterList.aryNews,
                      child: Text('Ary News'),
                    ),
                    PopupMenuItem<FilterList>(
                      value: FilterList.alJazeera,
                      child: Text('AlJazeera'),
                    ),
                    PopupMenuItem<FilterList>(
                      value: FilterList.reuters,
                      child: Text('Reuters'),
                    ),
                    PopupMenuItem<FilterList>(
                      value: FilterList.cnn,
                      child: Text('CNN'),
                    ),
                    PopupMenuItem<FilterList>(
                      value: FilterList.fortune,
                      child: Text('Fortune'),
                    ),
                  ]),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: height * .55,
            width: Width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlineApi(name),
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
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                height: height * 0.6,
                                width: Width * .9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
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
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                        newImage: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        newTitle: snapshot
                                            .data!.articles![index].title
                                            .toString(),
                                        newDate: snapshot
                                            .data!.articles![index].publishedAt
                                            .toString(),
                                        url: snapshot.data!.articles![index].url
                                            .toString(),
                                        description: snapshot
                                            .data!.articles![index].description
                                            .toString(),
                                        content: snapshot
                                            .data!.articles![index].content
                                            .toString(),
                                        source: snapshot
                                            .data!.articles![index].source!.name
                                            .toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.bottomCenter,
                                    height: height * 0.22,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: Width * 0.7,
                                          child: Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: Width * 0.7,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.categoriesNewsApi('General'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return Container(
                    height: height * .55,
                    child: ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(
                                    newImage: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    newTitle: snapshot
                                        .data!.articles![index].title
                                        .toString(),
                                    newDate: snapshot
                                        .data!.articles![index].publishedAt
                                        .toString(),
                                    url: snapshot.data!.articles![index].url
                                        .toString(),
                                    description: snapshot
                                        .data!.articles![index].description
                                        .toString(),
                                    content: snapshot
                                        .data!.articles![index].content
                                        .toString(),
                                    source: snapshot
                                        .data!.articles![index].source!.name
                                        .toString(),
                                  ),
                                ),
                              );
                            },
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
                                            fontWeight: FontWeight.bold,
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
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
