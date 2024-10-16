// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_management___bloc_pattern__timer_application__part_1/bloc/bloc.dart';
import 'package:state_management___bloc_pattern__timer_application__part_1/helpers/ticker.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(109, 234, 255, 1),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color.fromRGBO(72, 74, 126, 1),
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      home: BlocProvider(
        create: (_) => TimerBloc(ticker: Ticker()),
        child: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('StateMang_TimerApp_Bloc'),
      ),
      body: Stack(
        children: <Widget>[
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Center(
                  child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (_, state) {
                      final String minutsSection = ((state.duration / 60) % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      final String secondsSection = (state.duration % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      return Text(
                        '$minutsSection:$secondsSection',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<TimerBloc, TimerState>(
                buildWhen: (previosState, currentState) =>
                    currentState.runtimeType != previosState.runtimeType,
                builder: (_, state) => Actions(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(184, 189, 245, 0.7)
          ],
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(172, 182, 219, 0.7),
          ],
          [
            Color.fromRGBO(72, 73, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(190, 238, 246, 0.7),
          ],
        ],
        durations: [19440, 10000, 6000],
        heightPercentages: [0.03, 0.01, 0.02],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
      ),
      size: Size(double.infinity, double.infinity),
      backgroundColor: Colors.blue[50],
    );
  }
}

class Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _mapToStateActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> _mapToStateActionButtons({TimerBloc? timerBloc}) {
    final TimerState currentState = timerBloc!.state;
    if (currentState is Ready) {
      return [
        FloatingActionButton(
          onPressed: () {
            timerBloc.add(Start(duration: currentState.duration));
          },
          child: Icon(Icons.play_arrow),
        ),
      ];
    }
    if (currentState is Running) {
      return [
        FloatingActionButton(
          onPressed: () => timerBloc.add(Pause()),
          child: Icon(Icons.pause),
        ),
        FloatingActionButton(
          onPressed: () => timerBloc.add(Reset()),
          child: Icon(Icons.replay),
        ),
      ];
    }
    if (currentState is Paused) {
      return [
        FloatingActionButton(
          onPressed: () => timerBloc.add(
            Resume(),
          ),
          child: Icon(Icons.play_arrow),
        ),
        FloatingActionButton(
          onPressed: () => timerBloc.add(
            Reset(),
          ),
          child: Icon(Icons.replay),
        ),
      ];
    }
    if (currentState is Finished) {
      return [
        FloatingActionButton(
          onPressed: () => timerBloc.add(
            Reset(),
          ),
          child: Icon(Icons.replay),
        ),
      ];
    }
    return [];
  }
}
