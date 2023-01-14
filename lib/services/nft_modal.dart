// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NFTModel {
  late final String address;
  late final String title;
  late final String description;
  // late final String tokenURL;
  // late final String tokenId;
  // late final String tokenType;
  // late final String tokenUriRaw;
  // late final String tokenUriGateway;
  // late final String mediaRaw;
  late final String mediaGateWay;
  // late final String mediaFormat;
  // late final List metadata;

  NFTModel({
    required this.address,
    required this.title,
    required this.description,
    // required this.tokenURL,
    // required this.tokenId,
    // required this.tokenType,
    // required this.tokenUriRaw,
    // required this.tokenUriGateway,
    // required this.mediaRaw,
    required this.mediaGateWay,
    // required this.mediaFormat,
    // required this.metadata,
  });

  factory NFTModel.fromMap(Map<String, dynamic> map) {
    return NFTModel(
      address: map['contract']!["address"] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? '',
      // tokenURL: "",
      // tokenId: "",
      // tokenType: map['id']!['tokenMetadata']['tokenId'] ?? '',
      // tokenUriRaw: map['tokenUri']!['raw'] ?? '',
      // tokenUriGateway: map!['tokenUri']!['gateway']! ?? '',
      // mediaRaw: '',
      mediaGateWay: map['contractMetadata']['openSea']['imageUrl'] ??
          map['media'][0]['gateway']! ??
          map['metadata']['image'] ??
          map['tokenUri']['gateway'] ??
          '',
      // mediaFormat: map['media']!['format'] ?? '',
      // metadata: map['metadata']!['attributes'] ?? [],
    );
  }
}
