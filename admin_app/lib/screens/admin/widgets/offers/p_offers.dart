import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/server/server.dart';

import '../../../../providers/p_offer.dart';
import '../../../../widgets/w_file_picker.dart';

class OffersPage extends ConsumerStatefulWidget {
  const OffersPage({super.key});

  @override
  ConsumerState<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends ConsumerState<OffersPage> {
  Widget get content => Consumer(
        builder: (context, ref, _) {
          final offers = ref.watch(OffersNotififer.provider);
          final offersProvider = ref.read(OffersNotififer.provider.notifier);
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  child: Card(
                    child: GridView.builder(
                      itemCount: offers.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        final offer = offers[index];
                        return GridTile(
                          header: GridTileBar(
                              backgroundColor: Colors.black54,
                              leading: Tooltip(
                                message: 'Delete',
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => offersProvider.deleteOffer(
                                      offer.id, index),
                                ),
                              )),
                          child: CachedNetworkImage(
                            imageUrl: ServerConfigurations.getImageUrl(
                                offer.imageUrl),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                FilePickerWidget(
                  onPickFile: (file) async {
                    final error = await offersProvider.addOffer(file.path);
                    Future.microtask(
                      () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(error == null
                            ? 'Offer has been inserted!'
                            : 'Error $error'),
                      )),
                    );
                  },
                )
              ],
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final offersProvider = ref.read(OffersNotififer.provider.notifier);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Tooltip(
          message: 'Refresh',
          child: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(offersProvider.reset),
          ),
        ),
      ),
      body: offersProvider.isInitLoading
          ? FutureBuilder(
              future: offersProvider.loadOffers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                offersProvider.isInitLoading = false;
                return content;
              },
            )
          : content,
    );
  }
}
