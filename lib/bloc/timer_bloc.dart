import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/scheduler.dart';

class TimerState {
  Duration duration;
  late TimerEvent lastEvent;

  TimerState(this.duration, {this.lastEvent = TimerEvent.stop});

  get isStopped =>
      lastEvent == TimerEvent.pause || lastEvent == TimerEvent.stop;
}

enum TimerEvent { start, pause, reset, stop, tick }

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  late Ticker _ticker;
  final Stopwatch _watch = Stopwatch();

  TimerBloc() : super(TimerState(const Duration(milliseconds: 0))) {
    _ticker = Ticker(_onTick);
    on<TimerEvent>(_onEvent);
  }

  void _onTick(Duration duration) {
    add(TimerEvent.tick);
  }

  @override
  Future<void> close() async {
    super.close();
    _ticker.dispose();
  }

  FutureOr<void> _onEvent(TimerEvent event, Emitter<TimerState> emit) {
    switch (event) {
      case TimerEvent.start:
        if (!_ticker.isActive) {
          _ticker.start();
        }
        _watch.start();
        emit(TimerState(_watch.elapsed, lastEvent: event));
        break;
      case TimerEvent.pause:
        _watch.stop();
        emit(TimerState(_watch.elapsed, lastEvent: event));
        break;
      case TimerEvent.reset:
        _watch.reset();
        add(TimerEvent.tick);
        break;
      case TimerEvent.stop:
        _ticker.stop();
        add(TimerEvent.reset);
        emit(TimerState(_watch.elapsed, lastEvent: event));
        break;
      case TimerEvent.tick:
        emit(TimerState(_watch.elapsed, lastEvent: state.lastEvent));
        break;
    }
  }
}
