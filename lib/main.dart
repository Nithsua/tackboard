import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tackboard/model/tack.dart';
import 'package:tackboard/providers/theme_provider.dart';
import 'package:tackboard/services/tack_services.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Tackboard',
      theme: ref.watch(themeNotifierProvider.notifier).getThemeData(),
      home: const HomePage(title: 'Tackboard'),
    );
  }
}

final tackFutureProvider = FutureProvider<List<Tack>>((_) async {
  return (await TackServices.getMessages())
      .map((e) => Tack.fromJson(e as Map<String, dynamic>))
      .toList();
});

class HomePage extends ConsumerWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
        child: CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          largeTitle: Text(title),
          trailing: CupertinoButton(
            child: const Icon(CupertinoIcons.chat_bubble),
            onPressed: () {},
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async {},
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, _) {
              return ref.watch(tackFutureProvider).when(data: (tacks) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: tacks.length,
                    itemBuilder: (_, position) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: CupertinoColors.darkBackgroundGray,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              tacks[position].content,
                            ),
                          ),
                        ),
                      );
                    });
              }, error: (_, __) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Make sure you have internet",
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }, loading: () {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [CupertinoActivityIndicator()],
                    ),
                  ],
                );
              });
            }, childCount: 1),
          ),
        )
      ],
    ));
  }
}
