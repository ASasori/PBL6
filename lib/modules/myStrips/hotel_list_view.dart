import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../models/hotel.dart';
import '../../models/hotel_list_data.dart';
import '../../providers/theme_provider.dart';
import '../../utils/enum.dart';
import '../../utils/helper.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_card.dart';
import '../../widgets/list_cell_animation_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
class HotelListView extends StatelessWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final Hotel hotelByLocation;
  final AnimationController animationController;
  final Animation<double> animation;

  const HotelListView(
      {Key? key,
        required this.hotelByLocation,
        required this.animationController,
        required this.animation,
        required this.callback,
        this.isShowDate = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
      animation: animation,
      animationController: animationController,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
        child: Column(
          children: <Widget>[
            // isShowDate
            //     ? Padding(
            //   padding: const EdgeInsets.only(top: 12, bottom: 12),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         Helper.getDateText(hotelData.date!) + ', ',
            //         style: TextStyles(context)
            //             .getRegularStyle()
            //             .copyWith(fontSize: 14),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(top: 2.0),
            //         child: Text(
            //           Helper.getRoomText(hotelData.roomData!),
            //           style: TextStyles(context)
            //               .getRegularStyle()
            //               .copyWith(fontSize: 14),
            //         ),
            //       ),
            //     ],
            //   ),
            // )
            //     : SizedBox(),
            CommonCard(
              color: AppTheme.backgroundColor,
              radius: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 2,
                          child: CachedNetworkImage(
                            imageUrl: hotelByLocation.imageUrl,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Hiển thị khi ảnh đang load
                            errorWidget: (context, url, error) => Icon(Icons.error),     // Hiển thị khi có lỗi tải ảnh
                            fit: BoxFit.cover, // Tùy chỉnh cách hiển thị ảnh
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 8, bottom: 8, right: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        hotelByLocation.name,
                                        textAlign: TextAlign.left,
                                        style: TextStyles(context)
                                            .getBoldStyle()
                                            .copyWith(fontSize: 22),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          // Icon(
                                          //   FontAwesomeIcons.mapMarkerAlt,
                                          //   size: 12,
                                          //   color:
                                          //   Theme.of(context).primaryColor,
                                          // ),
                                          // Text(
                                          //   // "${hotelData.dist.toStringAsFixed(1)}",
                                          //   "${hotelByLocation.address}",
                                          //   overflow: TextOverflow.ellipsis,
                                          //   style: TextStyles(context)
                                          //       .getDescriptionStyle(),
                                          // ),
                                          Text(
                                            hotelByLocation.description,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles(context).getDescriptionStyle(),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),

                                          // Expanded(
                                          //   child: Text(
                                          //     AppLocalizations(context)
                                          //         .of("km_to_city"),
                                          //     overflow: TextOverflow.ellipsis,
                                          //     style: TextStyles(context)
                                          //         .getDescriptionStyle(),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: <Widget>[
                                            Helper.ratingStar(),
                                            Text(
                                              " ${hotelByLocation.views}",
                                              style: TextStyles(context)
                                                  .getDescriptionStyle(),
                                            ),
                                            Text(
                                              // AppLocalizations(context)
                                              //     .of("views"),
                                              " Views",
                                              style: TextStyles(context)
                                                  .getDescriptionStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       right: 16, top: 8, left: 16),
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     crossAxisAlignment: CrossAxisAlignment.end,
                            //     children: <Widget>[
                            //       Text(
                            //         "\$${hotelData.perNight}",
                            //         textAlign: TextAlign.left,
                            //         style: TextStyles(context)
                            //             .getBoldStyle()
                            //             .copyWith(fontSize: 22),
                            //       ),
                            //       Padding(
                            //         padding: EdgeInsets.only(
                            //             top: context
                            //                 .read<ThemeProvider>()
                            //                 .languageType ==
                            //                 LanguageType.ar
                            //                 ? 2.0
                            //                 : 0.0),
                            //         child: Text(
                            //           AppLocalizations(context).of("per_night"),
                            //           style: TextStyles(context)
                            //               .getDescriptionStyle(),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          onTap: () {
                            try {
                              callback();
                            } catch (e) {}
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: BoxShape.circle),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(
                              Radius.circular(32.0),
                            ),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.favorite_border,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String truncateDescription(String description, {int maxLength = 100}) {
    if (description.length <= maxLength) {
      return description; // Không cắt nếu mô tả ngắn hơn hoặc bằng maxLength
    }
    return '${description.substring(0, maxLength)}...'; // Cắt và thêm dấu chấm ba chấm
  }
}