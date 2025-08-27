import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:online_shop/common/widgets/custom_shapes/appbar/appbar.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/section_heading.dart';
import 'package:online_shop/common/widgets/custom_shapes/containers/t_circular_image.dart';
import 'package:online_shop/features/shop/products/widgets/profile_menu.dart';
import 'package:online_shop/utils/constants/image_strings.dart';
import 'package:online_shop/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:online_shop/utils/helpers/models/customer_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.customerModel});

  final CustomerModel customerModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _pickedImage;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _pickedImage = File(pickedFile.path);
    });

    await _uploadImage(File(pickedFile.path));
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _isUploading = true;
    });

    final fileName =
        'profile_pics/${DateTime.now().millisecondsSinceEpoch}.png';
    final storage = GetStorage();
    try {
      await supabase.storage.from('avatars').upload(fileName, imageFile);

      final publicUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

      final response = await supabase
          .from('customers')
          .update({'customerImage': publicUrl})
          .eq('customerID', storage.read("UID"));

      storage.write('UserImage', publicUrl);
      setState(() {
        _uploadedImageUrl = publicUrl;
        _isUploading = false;
      });
    } catch (e) {
      print('Upload error: $e');
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final displayedImage =
        _uploadedImageUrl != null
            ? NetworkImage(_uploadedImageUrl!)
            : _pickedImage != null
            ? FileImage(_pickedImage!) as ImageProvider
            : const AssetImage(TImages.appLightLogo);

    return Scaffold(
      appBar: const TAppBar(title: Text('Profile'), showBackArrrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          storage.read('UserImage').toString() == 'No Image'
                              ? AssetImage(TImages.appDarkLogo)
                              : NetworkImage(
                                    storage.read('UserImage').toString(),
                                  )
                                  as ImageProvider,
                    ),
                    const SizedBox(height: 8),
                    _isUploading
                        ? const CircularProgressIndicator()
                        : TextButton(
                          onPressed: _pickAndUploadImage,
                          child: const Text('Change Profile Picture'),
                        ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBetwwenItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBetwwenItems),

              const TSectionHeading(
                title: 'Profile Information',
                showActionButton: false,
              ),
              const SizedBox(height: TSizes.spaceBetwwenItems),

              TProfileMenuTitle(
                title: 'Name',
                value: widget.customerModel.customerName ?? '',
                onPressed: () {},
              ),
            
              const SizedBox(height: TSizes.spaceBetwwenItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBetwwenItems),

              const TSectionHeading(
                title: 'Personal Information',
                showActionButton: false,
              ),

              const SizedBox(height: TSizes.spaceBetwwenItems),
             
              TProfileMenuTitle(
                title: 'E-mail',
                value: widget.customerModel.customerEmail ?? '',
                onPressed: () {},
              ),
              TProfileMenuTitle(
                title: 'Phone Number',
                value: widget.customerModel.customerPhoneNumber ?? '',
                onPressed: () {},
              ),
            

              const Divider(),
              const SizedBox(height: TSizes.spaceBetwwenItems),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Close Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
