import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/app_view_model.dart';

class RewardArea extends StatefulWidget {
  const RewardArea({super.key});

  @override
  State<RewardArea> createState() => _RewardAreaState();
}

class _RewardAreaState extends State<RewardArea> {
  final List<String> rewards = [
    'Kaffee trinken',
    'Yoga machen',
    '10 Minuten nichts tun',
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppViewModel>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        leadingWidth: 130,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: viewModel.colorText,
        leading: Builder(
          builder: (context) => Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                color: viewModel.colorLight,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),

              SizedBox(
                width: 70,
                child: Image.asset(
                  'assets/images/logo_freigestellt.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),

        title: Text(
          'Task Drive',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'BungeeShade',
            fontSize: 36,
            fontWeight: FontWeight(600),
            color: viewModel.colorLight,
          ),
        ),
      ),

      drawer: Drawer(
        backgroundColor: viewModel.colorDark,
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                "Menü",
                style: TextStyle(fontFamily: 'BungeeInline', fontSize: 28),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.task),
              title: const Text(
                "Tasks",
                style: TextStyle(fontFamily: 'Alatsi', fontSize: 20),
              ),
              onTap: () {
                debugPrint("Aufgaben gedrückt");
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).maybePop();
              },
            ),

            ListTile(
              leading: const Icon(Icons.wallet_giftcard_rounded),
              title: const Text(
                "Tasks",
                style: TextStyle(fontFamily: 'Alatsi', fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RewardArea()),
                );
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: viewModel.colorDarkest,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Reward Area',
                style: TextStyle(
                  fontFamily: 'BungeeInline',
                  fontSize: 28,
                  color: viewModel.colorText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 8,
            child: ListView.builder(
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(rewards[index]));
              },
            ),
          ),

          FloatingActionButton(
            onPressed: () {
              setState(() {
                rewards.add("New Reward ${rewards.length}");
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
