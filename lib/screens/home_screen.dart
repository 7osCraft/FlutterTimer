import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/bloc/timer_bloc.dart';
import 'package:timer/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => TimerBloc(),
        child: const TimerWidget(),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TimerText(),
        const SizedBox(
          height: 100,
        ),
        BlocBuilder<TimerBloc, TimerState>(
          buildWhen: (prev, state) => prev.lastEvent != state.lastEvent,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: state.isStopped ? "Start" : "Pause",
                  verticalOffset: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      if (state.isStopped) {
                        context.read<TimerBloc>().add(TimerEvent.start);
                      } else {
                        context.read<TimerBloc>().add(TimerEvent.pause);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: state.isStopped ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(32)),
                      child: Icon(
                          state.isStopped ? Icons.play_arrow : Icons.pause,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                  ),
                ),
                Tooltip(
                  message: "Reset",
                  verticalOffset: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<TimerBloc>().add(TimerEvent.reset);
                    },
                    child: const Icon(Icons.replay, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    return Text(
      durationToString(duration),
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
