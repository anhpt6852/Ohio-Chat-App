import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_templates/core/commons/presentation/common_button.dart';
import 'package:ohio_templates/core/config/theme.dart';
import 'package:ohio_templates/feature/user_profile/data/models/user_profile_model.dart';

// final profileConfigNotifierProvider =
//     StateNotifierProvider<UserProfileNotifier, UserProfileState>(
//         (ref) => UserProfileNotifier(ref));
        
// class ProfileConfig extends ConsumerWidget {
//   ProfileConfig({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(),
//       ),
//     )
//   }
// }

// class UserProfileConfig extends StatelessWidget {
//   const UserProfileConfig({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       // ignore: prefer_const_literals_to_create_immutables
//       children: [
//         SizedBox(
//           height: 100,
//           width: 100,
//           child: Stack(children: [
//             CircleAvatar(
//               backgroundImage: AssetImage(""),
//             ),
//             Positioned(
//               child: SizedBox(
//                 height: 35,
//                 width: 35,
//                 child: CommonButton(
//                   child: ,
//                   onPressed: null,
//                 ),
//               ),
//             )
//           ]),
//         ),
//         ElevatedButton(
//             onPressed: () {},
//             child: Row(
//               children: [
//                 Icon(Icons.person),
//                 SizedBox(width: 20),
//                 Expanded(
//                     child: Text(UserModel.userName, style: t48M)),
//                 Icon(Icons.arrow_forward_ios)
//               ],
//             )),
//         ElevatedButton(
//             onPressed: () {},
//             child: Row(
//               children: [
//                 Icon(Icons.cake),
//                 SizedBox(width: 20),
//                 Expanded(child: Text(UserModel.userDob, style: t48M)),
//                 Icon(Icons.arrow_forward_ios)
//               ],
//             )),
//         ElevatedButton(
//             onPressed: () {},
//             child: Row(
//               children: [
//                 Icon(Icons.map),
//                 SizedBox(width: 20),
//                 Expanded(
//                     child: Text(UserModel.userCountry, style: t48M)),
//                 Icon(Icons.arrow_forward_ios)
//               ],
//             )),
//         ElevatedButton(
//             onPressed: () {},
//             child: Row(
//               children: [
//                 Icon(Icons.email),
//                 SizedBox(width: 20),
//                 Expanded(
//                     child: Text(UserModel.userEmail, style: t48M)),
//                 Icon(Icons.arrow_forward_ios)
//               ],
//             )),
//       ],
//     );
//   }
// }
