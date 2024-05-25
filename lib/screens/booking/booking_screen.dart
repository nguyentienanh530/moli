import 'package:moli/bloc/bookinghistory/booking_history_bloc.dart';
import 'package:moli/screens/booking/history_widget.dart';
import 'package:moli/screens/main/main_screen.dart';
import 'package:moli/utils/color_res.dart';
import 'package:moli/utils/custom/custom_widget.dart';
import 'package:moli/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyBookingScreen extends StatelessWidget {
  final Function()? onMenuClick;

  const MyBookingScreen({Key? key, this.onMenuClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingHistoryBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: ColorRes.themeColor5,
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  BgRoundIconWidget(
                    icon: Icons.menu_open_sharp,
                    onTap: onMenuClick,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocalizations.of(context)!.myBookings,
                    style: kLightWhiteTextStyle.copyWith(
                      fontSize: 20,
                      color: ColorRes.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
              builder: (context, state) {
                BookingHistoryBloc bookingHistoryBloc =
                    context.read<BookingHistoryBloc>();
                return state is BookingHistoryInitial
                    ? const LoadingData()
                    : bookingHistoryBloc.bookings.isEmpty
                        ? const Center(child: DataNotFound())
                        : SingleChildScrollView(
                            controller: bookingHistoryBloc.scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BookingHistoryWidget(
                                  bookings: bookingHistoryBloc.bookings,
                                  onUpdate: bookingHistoryBloc.updateData,
                                ),
                              ],
                            ),
                          );
              },
            ),
          ),
          // const UpcomingBookingWidget(),
        ],
      ),
    );
  }
}
