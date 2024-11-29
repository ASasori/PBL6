import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/providers/wish_list_provider.dart';
import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:booking_hotel_app/screens/bottom_tab/bottom_tab_screen.dart';
import 'package:booking_hotel_app/screens/explore_screen/components/time_date_view.dart';
import 'package:booking_hotel_app/screens/hotel_detail_screen/room_booking_view.dart';
import 'package:booking_hotel_app/screens/wishlist_screen/wishlist_screen.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../../language/appLocalizations.dart';
import '../../models/hotel.dart';
import '../../models/room_data.dart';
import '../../providers/room_provider.dart';
import '../../utils/enum.dart';
import '../../utils/helper.dart';
import '../../utils/text_styles.dart';
import '../explore_screen/components/room_popup_view.dart';

class RoomBookingScreen extends StatefulWidget {
  final Hotel hotelBooking;

  const RoomBookingScreen({super.key, required this.hotelBooking});

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> with TickerProviderStateMixin{
  late AnimationController animationController;

  DateTime? startDate = DateTime.now(); // Store selected start date
  DateTime? endDate =  DateTime.now().add(Duration(days: 5));
  RoomData roomData = RoomData(1,2,2);// Store selected end date
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<RoomProvider>(context, listen: false).getAllRoomtypeList(widget.hotelBooking.slug);
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          getAppBarUI(context,animationController),
          SizedBox (
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TimeDateView(
                    onDateChanged: (selectedStartDate, selectedEndDate) {
                      setState(() {
                        startDate = selectedStartDate;
                        endDate = selectedEndDate;
                      });
                    },
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child:_getRoomUi(
                    AppLocalizations(context).of("number_room"),
                    Helper.getRoomText(roomData), () {
                      _showPopUp();
                    }),
                )
              ],
            ),
          ),
          CommonButton(
            padding: EdgeInsets.only(top: 8, bottom: 24),
            buttonText: "Check Availability",
          ),
          Divider(
            height: 1,
          ),
          Expanded(
            child: Consumer <RoomProvider> (
                builder: (context,roomProvider, child) {
                return ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemCount: roomProvider.allRoomtypes.length,
                  itemBuilder: (context, index) {
                    var count = roomProvider.allRoomtypes.length > 10 ? 10 : roomProvider.allRoomtypes.length;
                    var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn)));
                    animationController.forward();
                    //room book view and room data
                    return RoomBookView(
                      roomTypeData: roomProvider.allRoomtypes[index],
                      hotelSlug: widget.hotelBooking.slug,
                      animation: animation,
                      animationController: animationController,
                      startDate: startDate!,
                      endDate:  endDate!,
                      roomData: roomData,
                    );
                  },
                );
              }
            )
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI(BuildContext context, AnimationController animationController) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
          bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          //   ),
          Expanded(
            child: Center(
              child: Text(
                widget.hotelBooking.name,
                style: TextStyles(context).getTitleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          badges.Badge(
            badgeContent: Consumer<WishlistProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            //position: badges.BadgePosition(start: 30, bottom: 30),

            child: IconButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => BottomTabScreen(initialBottomBarType: BottomBarType.Wishlist)));
                NavigationServices(context).gotoBottomTabScreen(bottomBarType: BottomBarType.Wishlist);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          //   )
        ],
      ),
    );
    // );
  }
  Widget _getRoomUi(String title, String subtitle, VoidCallback onTap) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
              onTap: onTap,
              child: Padding(
                padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyles(context)
                          .getDescriptionStyle()
                          .copyWith(fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      subtitle,
                      // "${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}",
                      style: TextStyles(context).getRegularStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) => RoomPopupView(
        roomData: roomData,
        barrierDismissible: true,
        onChange: (data) {
          setState(() {
            roomData = data;
            print("${Helper.getRoomText(roomData)}");
          });
        },
      ),
    );
  }
}
