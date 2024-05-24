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

class BookingHistoryWidget extends StatelessWidget {
  const BookingHistoryWidget({
    Key? key,
    required this.bookings,
    this.onUpdate,
  }) : super(key: key);
  final List<BookingData> bookings;
  final Function()? onUpdate;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        BookingData bookingData = bookings[index];
        return ItemHistoryBooking(
          bookingData: bookingData,
          onUpdate: onUpdate,
        );
      },
    );
  }
}

class ItemHistoryBooking extends StatelessWidget {
  const ItemHistoryBooking({
    Key? key,
    required this.bookingData,
    this.onUpdate,
  }) : super(key: key);
  final BookingData bookingData;
  final Function()? onUpdate;

  @override
  Widget build(BuildContext context) {
    var curentLoca = Localizations.localeOf(context).languageCode;
    return CustomCircularInkWell(
      onTap: () {
        Get.to(
          () => const BookingDetailsScreen(),
          arguments: bookingData.bookingId,
        )?.then((value) {
          onUpdate?.call();
        });
      },
      child: Container(
        decoration: const BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Row(
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
                    color: ColorRes.darkGray.withOpacity(0.1),
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
                          '${AppRes.formatDate(AppRes.parseDate(bookingData.date ?? '', pattern: 'yyyy-MM-dd', isUtc: false, locale: curentLoca), pattern: 'dd MMM, yyyy - EE', isUtc: false, locale: curentLoca)} - ${AppRes.convert24HoursInto12Hours(bookingData.time, curentLoca)}',
                          style: kLightWhiteTextStyle.copyWith(
                            color: ColorRes.themeColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          bookingData.salonData?.salonName ?? '',
                          style: kBoldThemeTextStyle.copyWith(
                            color: ColorRes.nero,
                            fontSize: 19,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          bookingData.salonData?.salonAddress ?? '',
                          style: kLightWhiteTextStyle.copyWith(
                            color: ColorRes.charcoal50,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              alignment: Alignment.centerRight,
              color:
                  AppRes.getTextColorByStatus(bookingData.status?.toInt() ?? 0)
                      .withOpacity(.2),
              child: Text(
                AppRes.getTextByStatus(bookingData.status?.toInt() ?? 0),
                style: kRegularTextStyle.copyWith(
                  color: AppRes.getTextColorByStatus(
                      bookingData.status?.toInt() ?? 0),
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
