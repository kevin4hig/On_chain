import 'package:on_chain/ethereum/src/rpc/core/core.dart';
import 'package:on_chain/ethereum/src/rpc/core/methods.dart';
import 'package:on_chain/ethereum/src/rpc/methds/subscribes/const/constant.dart';

/// https://geth.ethereum.org/docs/interacting-with-geth/rpc/pubsub
class EthereumRequestETHSubscribeNewHeads
    extends EthereumRequest<String, String> {
  EthereumRequestETHSubscribeNewHeads();

  @override
  String get method => EthereumMethods.ethSubscribe.value;

  @override
  List<dynamic> toJson() {
    return [EthereumRequestETHSubscribeConst.newHeads];
  }
}
