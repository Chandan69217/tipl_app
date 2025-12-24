import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tipl_app/core/widgets/custom_network_image.dart';

class ProfileImagePicker extends StatefulWidget {
  final String? imageUrl; // previously saved image URL
  final double size;
  final String name;
  final ValueChanged<File?> onImageSelected;

  const ProfileImagePicker({
    super.key,
    this.imageUrl,
    required this.name,
    required this.onImageSelected,
    this.size = 180,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (picked == null) return;

    final cropped = await _cropImage(File(picked.path));
    if (cropped != null) {
      setState(() => _selectedImage = cropped);
      widget.onImageSelected(cropped);
    }
  }

  Future<File?> _cropImage(File image) async {
    final CroppedFile? croppedFile =
    await ImageCropper().cropImage(
      sourcePath: image.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 75,

      aspectRatio: const CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,

          ],
          hideBottomControls :true,
        ),
      ]
    );

    if (croppedFile == null) return null;

    return File(croppedFile.path);
  }



  void _showPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final colors = _avatarColors(widget.name);

    return GestureDetector(
      onTap: _showPicker,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [


          CircularProfileAvatar(
            widget.imageUrl != null && widget.imageUrl!.isNotEmpty ? widget.imageUrl!:'',
            radius: widget.size / 2,
            initialsText: Text(
              widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '',
              style: TextStyle(
                fontSize: widget.size / 2,
                fontWeight: FontWeight.bold,
                color: colors.text,
              ),
            ),
            backgroundColor: Colors.grey.shade100,
            cacheImage: true,
            borderColor: colors.text,
            imageFit: BoxFit.cover,
            errorWidget: (context, _, __) => CustomNetworkImage(),
            placeHolder: (context, _) => CustomNetworkImage(),
            child: _selectedImage != null ? CustomNetworkImage(selectedFile: _selectedImage,):null,
          ),

          Container(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.text,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              size: 18,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }





  AvatarColorPair _avatarColors(String name) {
    final pairs = [
      AvatarColorPair(
        text: Colors.red,
        background: Colors.red.withValues(alpha: 0.15),
      ),
      AvatarColorPair(
        text: Colors.blue,
        background: Colors.blue.withValues(alpha: 0.15),
      ),
      AvatarColorPair(
        text: Colors.green,
        background: Colors.green.withValues(alpha: 0.15),
      ),
      AvatarColorPair(
        text: Colors.orange,
        background: Colors.orange.withValues(alpha: 0.15),
      ),
      AvatarColorPair(
        text: Colors.purple,
        background: Colors.purple.withValues(alpha: 0.15),
      ),
      AvatarColorPair(
        text: Colors.teal,
        background: Colors.teal.withValues(alpha: 0.15),
      ),
      AvatarColorPair(
        text: Colors.indigo,
        background: Colors.indigo.withValues(alpha: 0.15),
      ),
      AvatarColorPair(
        text: Colors.pink,
        background: Colors.pink.withValues(alpha: 0.15),
      ),
      AvatarColorPair(
        text: Colors.brown,
        background: Colors.brown.withValues(alpha: 0.15),
      ),
      AvatarColorPair(
        text: Colors.cyan,
        background: Colors.cyan.withValues(alpha: 0.15),
      ),
    ];

    if (name.trim().isEmpty) return pairs.first;

    final index = name.toUpperCase().codeUnitAt(0) % pairs.length;
    return pairs[index];
  }


}


class AvatarColorPair {
  final Color text;
  final Color background;

  const AvatarColorPair({
    required this.text,
    required this.background,
  });
}


