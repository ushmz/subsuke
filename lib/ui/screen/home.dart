import 'package:flutter/material.dart';
import 'package:subsuke/blocs/pagination_bloc.dart';
import 'package:subsuke/ui/pages/list.dart';
import 'package:subsuke/ui/pages/link.dart';
import 'package:subsuke/ui/pages/config.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final pagination = Provider.of<PaginationBloc>(context);
		return StreamBuilder(
			stream: pagination.currentPage,
			initialData: 0,
			builder: (context, snapshot) => Scaffold(
				appBar: AppBar(
					title: Text('subsuke'),
				),
				body: [
					ListPage(),
					LinkPage(),
					ConfigPage(),
				][snapshot.data],
				bottomNavigationBar: BottomNavigationBar(
					type: BottomNavigationBarType.fixed,
					items: [
						BottomNavigationBarItem(
							icon: Icon(
								Icons.list,
								size: 32,
								color: Colors.black12,
							),
							activeIcon: Icon(
								Icons.list,
								size: 32,
								color: Colors.purple,
							),
							label: 'ホーム'
						),
						BottomNavigationBarItem(
							icon: Icon(
								Icons.link,
								size: 32,
								color: Colors.black12,
							),
							activeIcon: Icon(
								Icons.link,
								size: 32,
								color: Colors.purple,
							),
							label: 'リンク'
						),
						BottomNavigationBarItem(
							icon: Icon(
								Icons.settings,
								size: 32,
								color: Colors.black12,
							),
							activeIcon: Icon(
								Icons.settings,
								size: 32,
								color: Colors.purple,
							),
							label: '設定'
						),
					],
					currentIndex: snapshot.data,
					onTap: (int index) {
              if (index == snapshot.data) return;
              switch (index) {
                case 0:
                  pagination.go(0);
                  break;
                case 1:
                  pagination.go(1);
                  break;
                case 2:
                  pagination.go(2);
                  break;
                case 3:
                  pagination.go(3);
                  break;
              }

					},
				),
			),
		);
	}
}
