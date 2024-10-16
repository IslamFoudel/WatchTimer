import 'dart:async';

import 'package:equatable/equatable.dart';

class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);

  @override
  List<Object?> get props => [duration];
}

class Ready extends TimerState {
  const Ready(super.duration);
}

class Paused extends TimerState {
  const Paused(super.duration);
}

class Running extends TimerState {
  const Running(super.duration);
}

class Finished extends TimerState {
  const Finished(int duration) : super(0);
}
