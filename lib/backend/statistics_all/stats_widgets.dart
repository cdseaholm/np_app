import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatsDropDownOptions extends StatefulHookConsumerWidget {
  const StatsDropDownOptions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StatsDropDownOptionsState();
}

class _StatsDropDownOptionsState extends ConsumerState<StatsDropDownOptions> {
  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> statViewOptions = [
      const DropdownMenuItem<String>(value: 'Graph', child: Text('Graph')),
      const DropdownMenuItem<String>(value: 'Bar', child: Text('Bar')),
      const DropdownMenuItem<String>(
          value: 'Projections', child: Text('Projections'))
    ];
    var currentOption = 'Graph';
    return DropdownButton<String>(
      icon: const Icon(Icons.arrow_drop_down),
      items: statViewOptions,
      onChanged: (String? value) {
        setState(() {
          currentOption = value!;
        });
      },
      value: currentOption,
    );
  }
}
