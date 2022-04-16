import 'package:rxdart/rxdart.dart';
import 'package:subsuke/models/subsucription.dart';

class EditScreenBloc {
  final _nameTextController = BehaviorSubject.seeded('');
  final _priceNumberController = BehaviorSubject.seeded(0);
  final _nextTimeController = BehaviorSubject.seeded('');
  final _cycleController = BehaviorSubject.seeded(Cycle.Monthly);
  final _noteController = BehaviorSubject.seeded('');

  Function(String) get setNameText => _nameTextController.sink.add;
  Stream<String> get onChangeNameText => _nameTextController.stream;
  String get getName => _nameTextController.value;

  Function(int) get setPriceNum => _priceNumberController.sink.add;
  Stream<int> get onChangePriceNum => _priceNumberController.stream;
  int get getPrice => _priceNumberController.value;

  Function(String) get setNextTime => _nextTimeController.sink.add;
  Stream<String> get onChangeNextTime => _nextTimeController.stream;
  String get getNextTime => _nextTimeController.value;

  Function(Cycle) get setCycle => _cycleController.sink.add;
  Stream<Cycle> get onChangeCycle => _cycleController.stream;
  Cycle get getCycle => _cycleController.value;

  Function(String) get setNote => _noteController.sink.add;
  Stream<String> get onChangeNote => _noteController.stream;
  String get getNote => _noteController.value;

  void dispose() {
    _nameTextController.close();
    _priceNumberController.close();
    _nextTimeController.close();
    _cycleController.close();
    _noteController.close();
  }
}
