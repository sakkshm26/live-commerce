import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchbase/constants/show_snackbar.dart';
import 'package:touchbase/features/home/screens/livestream_view.dart';
import 'package:touchbase/features/home/services/livestream_view_services.dart';
import 'package:touchbase/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  List? livestreams = [];
  var isLoaded = false;

  Future<void> getData() async {
    livestreams = await LivestreamViewServices().getLivestreams();
    if (livestreams == null) {
      if (context.mounted) {
        showCustomSnackBar(context: context, message: "Something went wrong");
      }
    } else {
      setState(() {
        isLoaded = true;
      });
    }
  }

  handleLivestreamClick(livestream) async {
    if (Provider.of<UserProvider>(context, listen: false).user == null) {
      showCustomSnackBar(context: context, message: "Login/Signup for viewing any livestream");
    } else {
      Navigator.pushNamed(context, LivestreamViewScreen.routeName, arguments: {"livestreamID": livestream["id"]});
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        forceMaterialTransparency: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: const Text(
            'TOUCHBASE',
            style: TextStyle(
                fontSize: 18, fontFamily: 'CabinetGrotesk', color: Color(0xFF141414), fontWeight: FontWeight.w800),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 17),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 26,
              ),
            ),
          )
        ],
      ),
      body: isLoaded
          ? livestreams!.isEmpty
              ? const Center(
                  child: Text("No livestreams right now!"),
                )
              : RefreshIndicator(
                  onRefresh: getData,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: List.generate(
                      livestreams!.isEmpty ? 0 : livestreams!.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            handleLivestreamClick(livestreams![index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: livestreams![index]["seller_profile_image"] != null
                                          ? NetworkImage(livestreams![index]["seller_profile_image"])
                                          : null,
                                      radius: 10,
                                      backgroundColor: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      livestreams![index]["seller_username"],
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: livestreams![index]["thumbnail"] != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                livestreams![index]["thumbnail"],
                                              ),
                                              fit: BoxFit.fill,
                                            )
                                          : DecorationImage(
                                              image: AssetImage(
                                                "assets/images/no_image.jpg",
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    // child: Card(
                                    //   elevation: 0,
                                    //   color: Colors.transparent,
                                    //   child: Column(
                                    //     children: [
                                    //       Padding(
                                    //         padding: const EdgeInsets.all(4),
                                    //         child: Row(
                                    //           mainAxisAlignment: MainAxisAlignment.start,
                                    //           children: [
                                    //             const Icon(
                                    //               Icons.visibility,
                                    //               color: Colors.red,
                                    //               size: 18,
                                    //             ),
                                    //             const SizedBox(
                                    //               width: 5,
                                    //             ),
                                    //             Text(
                                    //               "${livestreams![index]["viewers"]}",
                                    //               style:
                                    //                   const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      livestreams![index]["title"],
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
