import 'package:flutter/material.dart';
import 'package:wolfera/generated/assets.dart';

import 'edit_item_profile.dart';

class EditColumnItemsProfile extends StatelessWidget {
  const EditColumnItemsProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        EditItemProfile(
          svg: Assets.svgPerson,
          text: 'Name',
        ),
        EditItemProfile(
          svg: Assets.svgEmail,
          text: 'mat.07.mat.70.mat@gmail.com',
        ),
        EditItemProfile(
          svg: Assets.svgPhone,
          text: '+963 999 999 999',
        ),
      ],
    );
  }
}
