import 'package:cached_network_image/cached_network_image.dart';
import 'package:moli/model/bookings/booking.dart';
import 'package:moli/screens/bookingdetail/booking_detail_screen.dart';
import 'package:moli/utils/app_res.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/const_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpcomingBookingWidget extends StatelessWidget {
  const UpcomingBookingWidget({Key? key, required this.bookings})
      : super(key: key);
  final List<BookingData> bookings;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        BookingData bookingData = bookings[index];
        return ItemUpcomingBooking(
          bookingData: bookingData,
        );
      },
    );
  }
}

class ItemUpcomingBooking extends StatelessWidget {
  const ItemUpcomingBooking({
    Key? key,
    required this.bookingData,
  }) : super(key: key);
  final BookingData bookingData;

  @override
  Widget build(BuildContext context) {
    var curentLocale = Localizations.localeOf(context).languageCode;
    return CustomCircularInkWell(
      onTap: () {
        Get.to(
          () => const BookingDetailsScreen(),
          arguments: bookingData.bookingId,
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            SizedBox(
                height: 110,
                width: 110,
                child: CachedNetworkImage(
                    imageUrl:
                        '${ConstRes.itemBaseUrl}${bookingData.salonData!.images != null && bookingData.salonData!.images!.isNotEmpty ? bookingData.salonData!.images![0].image : ''}',
                    placeholder: (context, url) => const Loading(),
                    errorWidget: errorBuilderForImage,
                    fit: BoxFit.cover)),
            Expanded(
              child: Container(
                color: ColorRes.lavender50,
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 10,
                  right: 15,
                  left: 15,
                ),
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${AppRes.formatDate(
                        AppRes.parseDate(
                          bookingData.date ?? '',
                          pattern: 'yyyy-MM-dd',
                          isUtc: false,
                        ),
                        pattern: 'EE, MMM dd, yyyy',
                        isUtc: false,
                      )} : ${AppRes.convert24HoursInto12Hours(bookingData.time, curentLocale)}',
                      style: kLightWhiteTextStyle.copyWith(
                        color: ColorRes.themeColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      bookingData.salonData?.salonName ?? '',
                      style: kSemiBoldTextStyle.copyWith(
                        color: ColorRes.nero,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      bookingData.salonData?.salonAddress ?? '',
                      style: kThinWhiteTextStyle.copyWith(
                        color: ColorRes.titleText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
