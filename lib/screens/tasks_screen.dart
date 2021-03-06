import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:workos/constants/constants.dart';
import 'package:workos/data/ad_helper.dart';
import 'package:workos/inner_screen/upload_task.dart';
import 'package:workos/widgets/drawer_widget.dart';
import 'package:workos/widgets/task_widget.dart';

const int maxFailedLoadAttempts = 3;

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;
  String? taskCategoryFilter;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        }, onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        }));
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();
    }
  }

  @override
  void initState() {
    _createBottomBannerAd();
    _createInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        // leading: Builder(builder: (ctx) {
        //   return IconButton(
        //     icon: Icon(
        //       Icons.menu,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       Scaffold.of(ctx).openDrawer();
        //     },
        //   );
        // }),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "Tasks",
          style: TextStyle(color: Colors.pink),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showTaskCategoriesDialog(size: size);
              },
              icon: const Icon(
                Icons.filter_list_outlined,
                color: Colors.black,
              ))
        ],
      ),
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? Container(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: taskCategoryFilter == null
            ? FirebaseFirestore.instance
                .collection('tasks')
                .orderBy('createdAt', descending: true)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('tasks')
                .where('taskCategory', isEqualTo: taskCategoryFilter)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TaskWidget(
                      taskTitle: snapshot.data!.docs[index]['taskTitle'],
                      taskDescription: snapshot.data!.docs[index]
                          ['taskDescription'],
                      taskId: snapshot.data!.docs[index]['taskId'],
                      uploadedBy: snapshot.data!.docs[index]['uploadedBy'],
                      isDone: snapshot.data!.docs[index]['isDone'],
                    );
                  });
            } else {
              const Center(
                child: Text(
                  "There is no Tasks",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              );
            }
          }
          return const Center(
              child: Text(
            "No Task yet",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 2,
          hoverColor: Colors.grey.shade400,
          // backgroundColor: Colors.black,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Icon(
            Icons.add,
            size: 50,
            color: Constants.darkBlue,
          ),
          onPressed: () {
            _showInterstitialAd();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UploadTask()));
          }),
    );
  }

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Task category',
            style: TextStyle(color: Colors.pink.shade800),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
                itemCount: Constants.taskCategoryList.length,
                shrinkWrap:
                    true, //yesle chai content anusar wrap garxa dherai khali thau xodna didaina
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        taskCategoryFilter = Constants.taskCategoryList[index];
                      });
                      Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
                      // ignore: avoid_print
                      print(
                          'taskCategoryList[index], ${Constants.taskCategoryList[index]}');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.red.shade200,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Constants.taskCategoryList[index],
                            style: TextStyle(
                              color: Constants.darkBlue,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  taskCategoryFilter = null;
                });
                Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
              },
              child: const Text('Cancel filter'),
            ),
          ],
        );
      },
    );
  }
}
