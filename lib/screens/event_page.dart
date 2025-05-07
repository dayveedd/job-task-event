import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_task_event/provider/event_provider.dart';
import 'package:job_task_event/screens/error_page.dart';
import 'package:job_task_event/services/get_all_events.dart';
import 'package:job_task_event/utils/const.dart';
import 'package:job_task_event/utils/inward_curved_clipper.dart';
import 'package:job_task_event/utils/ticket_dialog.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  double _itemWidth = 350;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () {
        final index = (_scrollController.offset / _itemWidth).round();
        if (index != _currentIndex) {
          setState(() {
            _currentIndex = index;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) {
        // creating an instance of the dio
        final dio = Dio(
          BaseOptions(
            baseUrl: 'https://mocki.io',
            connectTimeout: Duration(seconds: 10),
            receiveTimeout: Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
        final repo = EventRepository(dio);
        final provider = EventProvider(repo);
        provider.fetchEvents();
        return provider;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Consumer<EventProvider>(
          builder: (context, provider, _) {
            switch (provider.status) {
              case EventStatus.loading:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case EventStatus.error:
                return ErrorPage(
                  onPressed: () {
                    provider.fetchEvents();
                  },
                );
              case EventStatus.loaded:
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Buy tickets to this events',
                              style: GoogleFonts.poppins(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        ClipPath(
                          clipper: InwardCurvedClipper(),
                          child: SizedBox(
                            height: width > 400
                                ? MediaQuery.of(context).size.height * 0.4
                                : MediaQuery.of(context).size.height * 0.385,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: provider.events.length,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final event = provider.events[index];
                                final image =
                                    eventImage[index % eventImage.length];
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 206,
                                        width: 340,
                                        // margin: EdgeInsets.symmetric(
                                        //   vertical: 10,
                                        // ),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // price tag
                                      Positioned(
                                        top: 12,
                                        left: 12,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 16.0,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 10,
                                                sigmaY: 10,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  '\$${event.eventPrice}',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Event info
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                event.eventName,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                event.eventSubtitle,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'images/svg/Calendar_duotone_line.svg',
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    event.eventDate,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  SvgPicture.asset(
                                                      'images/svg/Time.svg'),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    event.eventTime,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // the index indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            provider.events.length,
                            (index) {
                              final isActive = index == _currentIndex;
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive
                                      ? Colors.black
                                      : Colors.transparent,
                                  border: Border.all(color: Colors.black),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        // the buy now button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1BA95E),
                            foregroundColor: Colors.white,
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.7,
                              50,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => TicketDialog(),
                              barrierDismissible: false,
                              barrierColor: Colors.black.withOpacity(0.65),
                            );
                          },
                          child: Text(
                            'Buy now',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                provider.fetchEvents();
                              },
                              child: Text(
                                'Refresh',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
