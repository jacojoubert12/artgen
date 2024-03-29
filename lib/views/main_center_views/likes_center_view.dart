// import 'package:artgen/views/main_detail_views/image_details_view.dart';
// import 'package:flutter/material.dart';
// import 'package:artgen/components/side_menu.dart';
// import 'package:artgen/responsive.dart';
// import 'package:websafe_svg/websafe_svg.dart';

// import '../../../constants.dart';

// import 'package:flutter/foundation.dart' show kIsWeb;

// class LikesCenterView extends StatefulWidget {
//   const LikesCenterView({
//     Key? key,
//     this.setViewMode,
//   }) : super(key: key);
//   final Function? setViewMode;

//   @override
//   _LikesCenterViewState createState() => _LikesCenterViewState();
// }

// class _LikesCenterViewState extends State<LikesCenterView> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   List<String> imgUrls = [
//     "https://ws.artgen.fun/images/icon.png"
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: ConstrainedBox(
//         constraints: BoxConstraints(maxWidth: 250),
//         child: SideMenu(setViewMode: widget.setViewMode),
//       ),
//       body: Container(
//         padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
//         color: kBgDarkColor,
//         child: SafeArea(
//           right: false,
//           child: Column(
//             children: [
//               // This is our Seearch bar
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: kDefaultPadding),
//                 child: Row(
//                   children: [
//                     // Once user click the menu icon the menu shows like drawer
//                     // Also we want to hide this menu icon on desktop
//                     if (!Responsive.isDesktop(context))
//                       IconButton(
//                         icon: Icon(
//                           Icons.menu,
//                           color: kButtonLightPurple,
//                         ),
//                         onPressed: () {
//                           _scaffoldKey.currentState!.openDrawer();
//                         },
//                       ),
//                     if (!Responsive.isDesktop(context)) SizedBox(width: 5),
//                     Expanded(
//                       child: TextField(
//                         onChanged: (value) {},
//                         decoration: InputDecoration(
//                           hintText: "Search",
//                           fillColor: kBgLightColor,
//                           filled: true,
//                           suffixIcon: Padding(
//                             padding: const EdgeInsets.all(
//                                 kDefaultPadding * 0.75), //15
//                             child: WebsafeSvg.asset(
//                               "assets/Icons/Search.svg",
//                               width: 24,
//                             ),
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(10)),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: kDefaultPadding),
//               Container(
//                 padding: EdgeInsets.all(kDefaultPadding),
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   itemCount: imgUrls.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 5,
//                     childAspectRatio: 1,
//                   ),
//                   itemBuilder: (BuildContext context, int index) {
//                     return Container(
//                       child: GestureDetector(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return ImageDetailsModal(
//                                     selectedImageUrl: imageUrls[index],
//                                     selectedImageMeta: images[index],
//                                     onDelete: (String deletedImageUrl) {
//                                       setState(() {
//                                         imageUrls.removeAt(index);
//                                         images.removeAt(index);
//                                       });
//                                     },
//                                   );
//                             },
//                           );
//                           setState(() {});
//                         },
//                         child: NetworkImage(imgUrls[index]),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
