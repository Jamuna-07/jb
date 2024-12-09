import 'package:appwrite/models.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:jain_buzz/auth.dart';
import 'package:jain_buzz/constants/color.dart';
import 'package:jain_buzz/containers/event_container.dart';

import 'package:jain_buzz/database.dart';
import 'package:jain_buzz/saved_data.dart';

import 'package:jain_buzz/views/create_event_page.dart';
import 'package:jain_buzz/views/event_details.dart';
import 'package:jain_buzz/views/login.dart';
import 'package:jain_buzz/views/popular_item.dart';
import 'package:jain_buzz/views/profile_page.dart';

import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String userName = "User";
  List<Document> events = [];
  bool isLoading = true;

  @override
  void initState() {
    userName = SavedData.getUserName().split(" ")[0];
    // print(SavedData.getUserIsOrganized());
    refresh();
    super.initState();
  }

  void refresh() {
    getAllEvents().then((value) {
      events = value;
      isLoading = false;
      setState(() {});
    });

    // getUpcomingEvents().then((value) {
    //   events = value;
    //   isLoading = false;
    //   setState(() {});
    // });
    // getPastEvents().then((value) {
    //   events = value;
    //   isLoading = false;
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () async {
                  // logoutUser();
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));

                  refresh();
                },
                icon: const Icon(
                  Icons.account_circle,
                  color: kLightGreen,
                  size: 30,
                ))
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi $userName 👋",
                      style: const TextStyle(
                          color: kLightGreen,
                          fontSize: 32,
                          fontWeight: FontWeight.w600),
                    ),
                    const Text("Expore event around you",
                        style: TextStyle(
                            color: kLightGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    isLoading
                        ? const SizedBox()
                        : CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.99,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: [
                              ...List.generate(4, (index) {
                                return EventContainer(
                                  data: events[index],
                                );
                              }),
                            ],
                          ),
                    const SizedBox(height: 16),
                    const Text(
                      "Popular Events ",
                      style: TextStyle(
                        color: kLightGreen,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  color: const Color(0xFF2E2E2E),
                  child: isLoading
                      ? const SizedBox()
                      : Column(
                          children: [
                            for (int i = 0;
                                i < events.length && i < 5;
                                i++) ...[
                              PopularItem(
                                eventData: events[i],
                                index: i + 1,
                              ),
                              const Divider(),
                            ],
                          ],
                        ),
                )
              ]),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 2, top: 8, left: 6, right: 6),
                child: Text(
                  "All Events",
                  style: TextStyle(
                    color: kLightGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => EventContainer(data: events[index]),
                    childCount: events.length)),
          ],
        ),
        floatingActionButton:
            // SavedData.getUserIsOrganized() ==true?
            FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateEventPage()));
            refresh();
          },
          backgroundColor: kLightGreen,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        )
        // :null,
        );
  }
}
