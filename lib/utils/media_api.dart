import 'package:nft_museum/apis/raribel.dart';

Future<String> getThumbnailUrlByAddress(String address) async {
  Map<String, dynamic> data =
      await RaribleAPI().collectionByRawAddress(address);
  if (data['pic'].startsWith('ipfs://ipfs/')) {
    // return data['pic'].replaceAll("ipfs://", "https://rarible.mypinata.cloud/");
    return "https://img.rarible.com/prod/image/upload/t_avatar_big/prod-collections/${data['id']}/avatar/${data['pic'].replaceAll('ipfs://ipfs/', '')}";
  } else {
    return data['pic'];
  }
}
