// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_management___bloc_pattern__timer_application__part_1/helpers/ticker.dart';
import 'timer_events.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvents, TimerState> {
  final int _duration = 60;
  final Ticker _ticker;
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(Ready(60)) {
    // Handle Start event
    on<Start>((event, emit) {
      emit(Running(event.duration));
      _tickerSubscription?.cancel();
      _tickerSubscription =
          _ticker.tick(ticks: event.duration).listen((duration) {
        add(Tick(duration: duration));
      });
    });

    // Handle Pause event
    on<Pause>((event, emit) {
      if (state is Running) {
        _tickerSubscription?.pause();
        emit(Paused(state.duration));
      }
    });

    // Handle Resume event
    on<Resume>((event, emit) {
      if (state is Paused) {
        _tickerSubscription?.resume();
        emit(Running(state.duration));
      }
    });

    // Handle Reset event
    on<Reset>((event, emit) {
      _tickerSubscription?.cancel();
      emit(Ready(_duration));
    });

    // Handle Tick event
    on<Tick>((event, emit) {
      emit(event.duration > 0 ? Running(event.duration) : Finished(0));
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
