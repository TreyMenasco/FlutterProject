import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _storedValue;
  String? _operation;
  bool _startNewNumber = true;

  void _enterDigit(String digit) {
    setState(() {
      if (_display == 'Error' || _startNewNumber) {
        _display = digit;
        _startNewNumber = false;
      } else if (_display != '0') {
        _display += digit;
      } else {
        _display = digit;
      }
    });
  }

  void _enterDecimal() {
    setState(() {
      if (_display == 'Error' || _startNewNumber) {
        _display = '0.';
        _startNewNumber = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _selectOperation(String operation) {
    if (_display == 'Error') {
      _clear();
      return;
    }

    setState(() {
      if (_operation != null && !_startNewNumber) {
        final result = _calculate(
          _storedValue!,
          double.parse(_display),
          _operation!,
        );
        if (result == null) {
          _showError();
          return;
        }
        _storedValue = result;
        _display = _format(result);
      } else {
        _storedValue = double.parse(_display);
      }

      _operation = operation;
      _startNewNumber = true;
    });
  }

  void _equals() {
    if (_operation == null || _storedValue == null || _startNewNumber) return;

    setState(() {
      final result = _calculate(
        _storedValue!,
        double.parse(_display),
        _operation!,
      );

      if (result == null) {
        _showError();
        return;
      }

      _display = _format(result);
      _storedValue = null;
      _operation = null;
      _startNewNumber = true;
    });
  }

  double? _calculate(double first, double second, String operation) {
    return switch (operation) {
      '+' => first + second,
      '−' => first - second,
      '×' => first * second,
      '÷' => second == 0 ? null : first / second,
      _ => second,
    };
  }

  String _format(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(10).replaceFirst(RegExp(r'0+$'), '');
  }

  void _clear() {
    setState(() {
      _display = '0';
      _storedValue = null;
      _operation = null;
      _startNewNumber = true;
    });
  }

  void _backspace() {
    if (_display == 'Error' || _startNewNumber) return;

    setState(() {
      if (_display.length <= 1 ||
          (_display.startsWith('-') && _display.length == 2)) {
        _display = '0';
        _startNewNumber = true;
      } else {
        _display = _display.substring(0, _display.length - 1);
      }
    });
  }

  void _toggleSign() {
    if (_display == '0' || _display == 'Error') return;

    setState(() {
      _display = _display.startsWith('-')
          ? _display.substring(1)
          : '-$_display';
    });
  }

  void _showError() {
    _display = 'Error';
    _storedValue = null;
    _operation = null;
    _startNewNumber = true;
  }

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['C', '±', '⌫', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['0', '.', '='],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Semantics(
                      label: 'Calculator display',
                      value: _display,
                      child: Text(
                        _display,
                        key: const Key('calculatorDisplay'),
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              for (final row in rows)
                Expanded(
                  child: Row(
                    children: [
                      for (final label in row)
                        Expanded(
                          flex: row.length == 3 && label == '0' ? 2 : 1,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: _CalculatorButton(
                              label: label,
                              isOperation: const [
                                '÷',
                                '×',
                                '−',
                                '+',
                                '=',
                              ].contains(label),
                              onPressed: () => _handleButton(label),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleButton(String label) {
    if (RegExp(r'^\d$').hasMatch(label)) {
      _enterDigit(label);
    } else {
      switch (label) {
        case 'C':
          _clear();
        case '±':
          _toggleSign();
        case '⌫':
          _backspace();
        case '.':
          _enterDecimal();
        case '=':
          _equals();
        default:
          _selectOperation(label);
      }
    }
  }
}

class _CalculatorButton extends StatelessWidget {
  const _CalculatorButton({
    required this.label,
    required this.isOperation,
    required this.onPressed,
  });

  final String label;
  final bool isOperation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      key: Key('button_$label'),
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isOperation
            ? Theme.of(context).colorScheme.primary
            : const Color(0xFF2A2A2A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
      ),
      child: Text(label),
    );
  }
}
