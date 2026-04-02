import 'package:crabpay/home_view/bloc/home_pages_bloc/home_pages_bloc.dart';
import 'package:crabpay/home_view/bloc/home_pages_bloc/home_pages_event.dart';
import 'package:crabpay/home_view/bloc/home_pages_bloc/home_pages_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  //int _bottomNavigationBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePagesBloc, HomePagesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Crab Pay')),
          body: _bodyBuilder(state),
          bottomNavigationBar: NavigationBar(
            selectedIndex: state.index,
            onDestinationSelected: (value) {
              final bloc = context.read<HomePagesBloc>();
              if (value == 0) bloc.add(HomePagesEventHomeSelected());
              if (value == 1) bloc.add(HomePagesEventStoreSelected());
              if (value == 2) bloc.add(HomePagesEventWalletSelected());
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront),
                label: 'Sotre',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet),
                label: 'Wallet',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget? _bodyBuilder(HomePagesState state) {
    if (state is HomePagesStateHomePage) {
      return const Column(children: [Text('home row 1'), Text('home row 2')]);
    } else if (state is HomePagesStateStorePage) {
      return const Column(children: [Text('store row 1'), Text('store row 2')]);
    } else if (state is HomePagesStateWalletPage) {
      return const Column(
        children: [Text('wallet row 1'), Text('wallet row 2')],
      );
    }
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}
