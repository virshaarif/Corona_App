import 'package:corona/Model/WorldStatesModel.dart';
import 'package:corona/Services/states_services.dart';
import 'package:corona/View/country_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStates extends StatefulWidget {
  const WorldStates({super.key});

  @override
  State<WorldStates> createState() => _WorldStatesState();
}

class _WorldStatesState extends State<WorldStates>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorlist = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              FutureBuilder(
                future: statesServices.fetchWorldStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                        controller: _controller,
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total": double.parse(
                              snapshot.data!.cases.toString(),
                            ),
                            "Recovered": double.parse(
                              snapshot.data!.recovered.toString(),
                            ),
                            "Deaths": double.parse(
                              snapshot.data!.deaths.toString(),
                            ),
                          },
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          legendOptions: const LegendOptions(
                            legendPosition: LegendPosition.left,
                          ),
                          animationDuration: Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorlist,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.06,
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                reusable(
                                  title: 'Total',
                                  value: snapshot.data!.cases.toString(),
                                ),
                                reusable(
                                  title: 'Deaths',
                                  value: snapshot.data!.deaths.toString(),
                                ),
                                reusable(
                                  title: 'Recovered',
                                  value: snapshot.data!.recovered.toString(),
                                ),
                                reusable(
                                  title: 'Active',
                                  value: snapshot.data!.active.toString(),
                                ),
                                reusable(
                                  title: 'Critical',
                                  value: snapshot.data!.critical.toString(),
                                ),
                                reusable(
                                  title: 'Today Deaths',
                                  value: snapshot.data!.todayDeaths.toString(),
                                ),
                                reusable(
                                  title: 'Today Recovered',
                                  value: snapshot.data!.todayRecovered
                                      .toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountryStates(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xff1aa260),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text('Track Countries')),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class reusable extends StatelessWidget {
  String title, value;
  reusable({Key? key, required this.title, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value)],
          ),
          SizedBox(height: 5),
          Divider(),
        ],
      ),
    );
  }
}
