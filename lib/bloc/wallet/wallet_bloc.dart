import 'package:moli/model/user/salon_user.dart';
import 'package:moli/model/wallet/wallet_statement.dart';
import 'package:moli/service/api_service.dart';
import 'package:moli/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    scrollController.addListener(() {
      if (scrollController.offset ==
              scrollController.position.maxScrollExtent &&
          !isFetching) {
        add(FetchWalletStatementsEvent());
      }
    });
    on<FetchSalonDataEvent>(
      (event, emit) async {
        await ApiService().fetchMyUserDetails();
        SharePref sharePref = await SharePref().init();
        salonUser = sharePref.getSalonUser();
        emit(SalonDataFoundState());
        walletStatements = [];
        add(FetchWalletStatementsEvent());
      },
    );
    on<FetchWalletStatementsEvent>(
      (event, emit) async {
        WalletStatement walletStatement = await ApiService()
            .fetchSalonWalletStatement(walletStatements.length);
        walletStatements.addAll(walletStatement.data ?? []);
        emit(WalletStatementDataFoundState());
      },
    );
    add(FetchSalonDataEvent());
  }

  ScrollController scrollController = ScrollController();
  SalonUser? salonUser;
  bool isFetching = false;
  int count = 0;
  List<WalletStatementData> walletStatements = [];
}
