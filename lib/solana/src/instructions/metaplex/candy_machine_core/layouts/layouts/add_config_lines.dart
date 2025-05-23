import 'package:on_chain/solana/src/instructions/metaplex/candy_machine_core/layouts/instruction/instruction.dart';
import 'package:on_chain/solana/src/instructions/metaplex/candy_machine_core/types/candy_machine_types/types/config_line.dart';
import 'package:blockchain_utils/layout/layout.dart';

class MetaplexCandyMachineAddConfigLinesLayout
    extends MetaplexCandyMachineProgramLayout {
  final List<ConfigLine> configLines;
  MetaplexCandyMachineAddConfigLinesLayout(
      {required List<ConfigLine> configLines, required this.index})
      : configLines = List.unmodifiable(configLines);

  factory MetaplexCandyMachineAddConfigLinesLayout.fromBuffer(List<int> data) {
    final decode = MetaplexCandyMachineProgramLayout.decodeAndValidateStruct(
        layout: _layout,
        bytes: data,
        instruction:
            MetaplexCandyMachineProgramInstruction.addConfigLines.insturction);
    return MetaplexCandyMachineAddConfigLinesLayout(
        configLines: (decode['configLines'] as List)
            .map((e) => ConfigLine.fromJson(e))
            .toList(),
        index: decode['index']);
  }

  final int index;
  static final StructLayout _layout = LayoutConst.struct([
    LayoutConst.blob(8, property: 'instruction'),
    LayoutConst.u32(property: 'index'),
    LayoutConst.vec(ConfigLine.staticLayout, property: 'configLines')
  ]);

  @override
  late final StructLayout layout = _layout;

  @override
  MetaplexCandyMachineProgramInstruction get instruction =>
      MetaplexCandyMachineProgramInstruction.addConfigLines;

  @override
  Map<String, dynamic> serialize() {
    return {
      'index': index,
      'configLines': configLines.map((e) => e.serialize()).toList()
    };
  }
}
