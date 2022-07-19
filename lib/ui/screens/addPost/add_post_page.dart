import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tawari/data/env/env.dart';
import 'package:tawari/domain/blocs/blocs.dart';
import 'package:tawari/domain/blocs/post/post_bloc.dart';
import 'package:tawari/ui/helpers/helpers.dart';
import 'package:tawari/ui/screens/home/home_page.dart';
import 'package:tawari/ui/themes/colors_tbd.dart';
import 'package:tawari/ui/widgets/widgets.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  late TextEditingController _descriptionController;
  final _keyForm = GlobalKey<FormState>();
  late List<AssetEntity> _mediaList = [];
  late File fileImage;

  @override
  void initState() {
    _assetImagesDevice();
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  _assetImagesDevice() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      if (albums.isNotEmpty) {
        List<AssetEntity> photos = await albums[0].getAssetListPaged(page: 0, size: 50);
        setState(() => _mediaList = photos);
      }
    } else {
      PhotoManager.openSetting();
      print('err happened');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context).state;
    final postBloc = BlocProvider.of<PostBloc>(context);
    final size = MediaQuery.of(context).size;

    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is LoadingPost) {
          modalLoading(context, 'Creating posts...');
        } else if (state is FailurePost) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state is SuccessPost) {
          Navigator.pop(context);
          modalSuccess(context, 'Post created!',
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context, routeSlide(page: const HomePage()), (_) => false));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Form(
          key: _keyForm,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _appBarPost(),
                const SizedBox(height: 10.0),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 120,
                                  width: size.width * .125,
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        Environment.baseUrl +
                                            userBloc.user!.image),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 100,
                              width: size.width * .78,
                              color: Colors.white,
                              child: TextFormField(
                                controller: _descriptionController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 10.0, top: 10.0),
                                    border: InputBorder.none,
                                    hintText: 'add a comment',
                                    hintStyle:
                                        GoogleFonts.roboto(fontSize: 18)),
                                validator: RequiredValidator(
                                    errorText: 'The field is required'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 65.0, right: 10.0),
                          child: BlocBuilder<PostBloc, PostState>(
                              buildWhen: (previous, current) =>
                                  previous != current,
                              builder: (_, state) => (state.imageFileSelected !=
                                      null)
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          state.imageFileSelected!.length,
                                      itemBuilder: (_, i) => Stack(
                                        children: [
                                          Container(
                                            height: 150,
                                            width: size.width * .95,
                                            margin: const EdgeInsets.only(
                                                bottom: 10.0),
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(state
                                                            .imageFileSelected![
                                                        i]))),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: InkWell(
                                              onTap: () => postBloc.add(
                                                  OnClearSelectedImageEvent(i)),
                                              child: const CircleAvatar(
                                                backgroundColor: Colors.black38,
                                                child: Icon(Icons.close_rounded,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox()),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 90,
                  width: size.width,
                  // color: Colors.amber,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mediaList.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () async {
                          fileImage = (await _mediaList[i].file)!;
                          postBloc.add(OnSelectedImageEvent(fileImage));
                        },
                        child: FutureBuilder(
                          future: _mediaList[i].thumbnailDataWithSize(
                              const ThumbnailSize(200, 200)),
                          builder:
                              (context, AsyncSnapshot<Uint8List?> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Container(
                                height: 85,
                                width: 100,
                                margin: const EdgeInsets.only(right: 5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(snapshot.data!))),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5.0),
                const Divider(),
                InkWell(
                  onTap: () => modalPrivacyPost(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        BlocBuilder<PostBloc, PostState>(builder: (_, state) {
                          if (state.privacyPost == 1) {
                            return const Icon(Icons.public_rounded);
                          }
                          if (state.privacyPost == 2) {
                            return const Icon(Icons.group_outlined);
                          }
                          if (state.privacyPost == 3) {
                            return const Icon(Icons.lock_outline_rounded);
                          }
                          return const SizedBox();
                        }),
                        const SizedBox(width: 5.0),
                        BlocBuilder<PostBloc, PostState>(builder: (_, state) {
                          if (state.privacyPost == 1) {
                            return const TextCustom(
                                text: 'everyone can comment', fontSize: 16);
                          }
                          if (state.privacyPost == 2) {
                            return const TextCustom(
                                text: 'only followers', fontSize: 16);
                          }
                          if (state.privacyPost == 3) {
                            return const TextCustom(
                                text: 'No one', fontSize: 16);
                          }
                          return const SizedBox();
                        }),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 5.0),
                SizedBox(
                  height: 40,
                  width: size.width,
                  child: Row(
                    children: [
                      IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            AppPermission()
                                .permissionAccessGalleryMultiplesImagesNewPost(
                                    kIsWeb
                                        ? PermissionStatus.granted
                                        : await Permission.storage.request(),
                                    context);
                          },
                          icon: SvgPicture.asset('assets/svg/gallery.svg')),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            if (kIsWeb) {
                              AppPermission()
                                  .permissionAccessGalleryOrCameraForNewPost(
                                      PermissionStatus.granted,
                                      context,
                                      ImageSource.camera);
                            } else {
                              AppPermission()
                                  .permissionAccessGalleryOrCameraForNewPost(
                                      await Permission.camera.request(),
                                      context,
                                      ImageSource.camera);
                            }
                          },
                          icon: SvgPicture.asset('assets/svg/camera.svg')),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/svg/gif.svg')),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: SvgPicture.asset('assets/svg/location.svg')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _appBarPost() {
    final postBloc = BlocProvider.of<PostBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            splashRadius: 20,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page: const HomePage()), (_) => false),
            icon: const Icon(Icons.close_rounded)),
        BlocBuilder<PostBloc, PostState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) => TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  backgroundColor: ColorsTbd.primary,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0))),
              onPressed: () {
                if (_keyForm.currentState!.validate()) {
                  if (state.imageFileSelected != null) {
                    postBloc.add(
                        OnAddNewPostEvent(_descriptionController.text.trim()));
                  } else {
                    modalWarning(context, 'There are no selected images!');
                  }
                }
              },
              child: const TextCustom(
                text: 'Post',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: .7,
              )),
        )
      ],
    );
  }
}
