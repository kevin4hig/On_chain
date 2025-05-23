import 'package:on_chain/solana/src/address/sol_address.dart';
import 'package:on_chain/solana/src/instructions/metaplex/bubblegum/bubblegum.dart';
import 'package:on_chain/solana/src/instructions/metaplex/token_meta_data/types/types.dart';
import 'package:blockchain_utils/layout/layout.dart';
import 'package:on_chain/solana/src/borsh_serialization/program_layout.dart';
import 'package:on_chain/solana/src/utils/layouts.dart';

class _Utils {
  static final StructLayout layout = LayoutConst.struct([
    LayoutConst.u8(property: 'key'),
    SolanaLayoutUtils.publicKey('updateAuthority'),
    SolanaLayoutUtils.publicKey('mint'),
    MetaDataData.staticLayout,
    LayoutConst.boolean(property: 'primarySaleHappened'),
    LayoutConst.boolean(property: 'isMutable'),
    LayoutConst.optional(LayoutConst.u8(), property: 'editionNonce'),
    LayoutConst.optional(MetaDataTokenStandard.staticLayout,
        property: 'tokenStandard'),
    LayoutConst.optional(Collection.staticLayout, property: 'collection'),
    LayoutConst.optional(Uses.staticLayout, property: 'uses'),
    LayoutConst.optional(CollectionDetailsV1.staticLayout,
        property: 'collectionDetails'),
    LayoutConst.optional(ProgrammableConfigRecord.staticLayout,
        property: 'programmableConfigRecord'),
  ]);
}

class Metadata extends LayoutSerializable {
  final MetaDataKey key;
  final SolAddress updateAuthority;
  final SolAddress mint;
  final MetaDataData data;
  final bool primarySaleHappened;
  final bool isMutable;
  final int? editionNonce;
  final MetaDataTokenStandard? tokenStandard;
  final Collection? collection;
  final Uses? uses;
  final CollectionDetailsV1? collectionDetails;
  final ProgrammableConfigRecord? programmableConfigRecord;

  Metadata(
      {required this.key,
      required this.updateAuthority,
      required this.mint,
      required this.data,
      required this.primarySaleHappened,
      required this.isMutable,
      required this.editionNonce,
      required this.tokenStandard,
      required this.collection,
      required this.uses,
      required this.collectionDetails,
      required this.programmableConfigRecord});
  factory Metadata.fromBuffer(List<int> data) {
    final decode =
        LayoutSerializable.decode(bytes: data, layout: _Utils.layout);
    return Metadata(
        key: MetaDataKey.fromValue(decode['key']),
        updateAuthority: decode['updateAuthority'],
        mint: decode['mint'],
        data: MetaDataData.fromJson(decode['metaDataData']),
        primarySaleHappened: decode['primarySaleHappened'],
        isMutable: decode['isMutable'],
        editionNonce: decode['editionNonce'],
        tokenStandard: decode['tokenStandard'] == null
            ? null
            : MetaDataTokenStandard.fromJson(decode['tokenStandard']),
        collection: decode['collection'] == null
            ? null
            : Collection.fromJson(decode['collection']),
        uses: decode['uses'] == null ? null : Uses.fromJson(decode['uses']),
        collectionDetails: decode['collectionDetails'] == null
            ? null
            : CollectionDetailsV1.fromJson(decode['collectionDetails']),
        programmableConfigRecord: decode['programmableConfigRecord'] == null
            ? null
            : ProgrammableConfigRecord.fromJson(
                decode['programmableConfigRecord']));
  }

  @override
  StructLayout get layout => _Utils.layout;
  @override
  Map<String, dynamic> serialize() {
    return {
      'key': key.value,
      'updateAuthority': updateAuthority,
      'mint': mint,
      'metaDataData': data.serialize(),
      'primarySaleHappened': primarySaleHappened,
      'isMutable': isMutable,
      'editionNonce': editionNonce,
      'tokenStandard': tokenStandard?.serialize(),
      'collection': collection?.serialize(),
      'uses': uses?.serialize(),
      'collectionDetails': collectionDetails?.serialize(),
      'programmableConfigRecord': programmableConfigRecord?.serialize()
    };
  }
}
