import 'package:on_chain/solana/src/exception/exception.dart';
import 'package:blockchain_utils/layout/layout.dart';
import 'package:on_chain/solana/src/address/sol_address.dart';
import 'package:on_chain/solana/src/instructions/spl_token/types/types.dart';
import 'package:on_chain/solana/src/borsh_serialization/program_layout.dart';
import 'package:on_chain/solana/src/utils/layouts.dart';
import 'token_account.dart';

class _Utils {
  static final StructLayout layout = LayoutConst.struct([
    LayoutConst.boolean32(property: 'mintAuthorityOption'),
    SolanaLayoutUtils.publicKey('mintAuthority'),
    LayoutConst.u64(property: 'supply'),
    LayoutConst.u8(property: 'decimals'),
    LayoutConst.boolean(property: 'isInitialized'),
    LayoutConst.boolean32(property: 'freezeAuthorityOption'),
    SolanaLayoutUtils.publicKey('freezeAuthority'),
  ]);

  static int get mintSize => layout.span;
}

/// Mint data.
class SolanaMintAccount extends LayoutSerializable {
  static int get size => _Utils.mintSize;
  final SolAddress address;

  /// Optional authority used to mint new tokens. The mint authority may only
  /// be provided during mint creation. If no mint authority is present
  /// then the mint has a fixed supply and no further tokens may be
  /// minted.
  final SolAddress? mintAuthority;

  /// Total supply of tokens.
  final BigInt supply;

  /// Number of base 10 digits to the right of the decimal place.
  final int decimals;

  /// Is `true` if this structure has been initialized
  final bool isInitialized;

  /// Optional authority to freeze token accounts.
  final SolAddress? freezeAuthority;
  // final List<int> tlvData;

  const SolanaMintAccount(
      {required this.address,
      required this.mintAuthority,
      required this.supply,
      required this.decimals,
      required this.isInitialized,
      required this.freezeAuthority});
  factory SolanaMintAccount.fromBuffer(
      {required List<int> data, required SolAddress address}) {
    if (data.length < _Utils.mintSize) {
      throw SolanaPluginException('Account data length is insufficient.',
          details: {'Expected': _Utils.mintSize, 'length': data.length});
    }

    final decode =
        LayoutSerializable.decode(bytes: data, layout: _Utils.layout);
    final bool mintAuthorityOption = decode['mintAuthorityOption'];
    final bool freezeAuthorityOption = decode['freezeAuthorityOption'];
    if (data.length > _Utils.mintSize) {
      if (data.length <= SolanaTokenAccountUtils.accountSize) {
        throw const SolanaPluginException('Invalid account size');
      }
      final accountType = SolanaTokenAccountType.fromValue(
          data[SolanaTokenAccountUtils.accountSize]);
      if (accountType != SolanaTokenAccountType.mint) {
        throw SolanaPluginException('Invalid account type.', details: {
          'account type': accountType.name,
          'expected': SolanaTokenAccountType.mint
        });
      }
    }
    return SolanaMintAccount(
      address: address,
      mintAuthority: mintAuthorityOption ? decode['mintAuthority'] : null,
      supply: decode['supply'],
      decimals: decode['decimals'],
      isInitialized: decode['isInitialized'],
      freezeAuthority: freezeAuthorityOption ? decode['freezeAuthority'] : null,
    );
  }

  @override
  StructLayout get layout => _Utils.layout;
  @override
  Map<String, dynamic> serialize() {
    return {
      'mintAuthorityOption': mintAuthority == null ? false : true,
      'mintAuthority': mintAuthority ?? SolAddress.defaultPubKey,
      'supply': supply,
      'decimals': decimals,
      'isInitialized': isInitialized,
      'freezeAuthorityOption': freezeAuthority == null ? false : true,
      'freezeAuthority': freezeAuthority ?? SolAddress.defaultPubKey
    };
  }

  @override
  String toString() {
    return 'SolanaMintAccount${serialize()}';
  }
}
