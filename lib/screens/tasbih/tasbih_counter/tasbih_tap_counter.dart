import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:minimal_adhan/screens/tasbih/tasbih_counter/widgets/AnimatedTasbih.dart';

class TasbihTapCounter extends StatefulWidget {
  const TasbihTapCounter({Key? key}) : super(key: key);

  @override
  _TasbihTapCounterState createState() => _TasbihTapCounterState();
}

class _TasbihTapCounterState extends State<TasbihTapCounter> {
  final PageController _controller =
      PageController(viewportFraction: 0.1, initialPage: 5);
  final int _numberOfCountsToCompleteRound = 33;
  int _imageIndex = 1;
  int _beadCounter = 0;
  int _roundCounter = 0;
  int _accumulatedCounter = 0;
  bool _canVibrate = true;
  bool _isDisposed = false;
  final List<Color> _bgColour = [
    Colors.teal.shade50,
    Colors.lime.shade50,
    Colors.lightBlue.shade50,
    Colors.pink.shade50,
    Colors.black12
  ];
  final CarouselController _buttonCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _clicked,
        onVerticalDragStart: (_) => _clicked(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          _Counter(
                              counter: _roundCounter, counterName: 'Round'),
                          _Counter(counter: _beadCounter, counterName: 'Beads'),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Accumulated'),
                            const SizedBox(width: 10),
                            AnimatedTasbih(
                                value: _accumulatedCounter,
                                duration: const Duration(milliseconds: 730),
                                size: 14),
                          ],
                        ),
                      ),

                      const Spacer()
                    ],
                  ),
                )),
            Expanded(
              flex: 1,
              child: PageView.builder(
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, position) {
                  return FittedBox(
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                  );
                },
                itemCount: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadSettings() async {
    /*bool canVibrate = await Vibration.hasVibrator();
    if (!_isDisposed) {
      setState(() {
        _canVibrate = canVibrate;
        _loadData();
      });
    }*/
  }

  void _loadData() {
    /*if (!_isDisposed) {
      setState(() {
        _beadCounter = GetStorage().read(kBeadsCount) ?? 0;
        _roundCounter = GetStorage().read(kRoundCount) ?? 0;
        _accumulatedCounter =
            _roundCounter * _numberOfCountsToCompleteRound + _beadCounter;
      });
    }*/
  }

  void _resetEverything() {
    /* GetStorage().write(kBeadsCount, 0);
    GetStorage().write(kRoundCount, 0);
    _loadData();*/
  }

  void _clicked() {
    if (!_isDisposed) {
      setState(() {
        _beadCounter++;
        _accumulatedCounter++;
        if (_beadCounter > _numberOfCountsToCompleteRound) {
          _beadCounter = 1;
          _roundCounter++;
          //if (_canVibrate) Vibration.vibrate(duration: 100, amplitude: 100);
        }
      });
    }
    //GetStorage().write(kBeadsCount, _beadCounter);
    //GetStorage().write(kRoundCount, _roundCounter);
    int nextPage = (_controller.page?.round() ?? 0) + 1;
    _controller.animateToPage(nextPage,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}

class _Counter extends StatelessWidget {
  const _Counter(
      {Key? key,
      required this.counter,
      this.tsCounter =
          const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
      required this.counterName,
      this.tsCounterName = const TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300)})
      : super(key: key);
  final int counter;
  final TextStyle tsCounter;
  final String counterName;
  final TextStyle tsCounterName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedTasbih(
          duration: const Duration(milliseconds: 300),
          value: counter,
        ),
        Text(counterName, style: tsCounterName)
      ],
    );
  }
}

void confirmReset(BuildContext context, VoidCallback callback) {
  const _confirmText = Text('Confirm', style: TextStyle(color: Colors.red));
  const _cancelText = Text('Cancel');
  const _dialogTitle = Text("Reset Counter?");
  const _dialogContent = Text("This action can't be undone");

  void _confirmResetAction() {
    callback();
    showSnackBar(
        context: context,
        label: 'Cleared',
        icon: CupertinoIcons.check_mark_circled);
    Navigator.of(context).pop();
  }

  showDialog(
    context: context,
    builder: (_) {
      return kIsWeb
          ? AlertDialog(
              title: _dialogTitle,
              content: _dialogContent,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: _cancelText,
                ),
                TextButton(
                  onPressed: _confirmResetAction,
                  child: _confirmText,
                ),
              ],
            )
          : CupertinoAlertDialog(
              title: _dialogTitle,
              content: _dialogContent,
              actions: [
                CupertinoDialogAction(
                  child: _cancelText,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoDialogAction(
                  child: _confirmText,
                  onPressed: _confirmResetAction,
                ),
              ],
            );
    },
  );
}

void showSnackBar(
    {required BuildContext context,
    required String label,
    required IconData icon}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white60,
          ),
          const SizedBox(width: 5),
          Text(label)
        ],
      ),
    ),
  );
}
