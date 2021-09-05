import 'package:rxdart/rxdart.dart';

class EditScreenBloc {
  final _nameTextController = BehaviorSubject.seeded('');
  final _priceNumberController = BehaviorSubject.seeded('');
  final _nextTimeController = BehaviorSubject.seeded('');
  final _cycleController = BehaviorSubject.seeded('');

  Function(String) get setNameText => _nameTextController.sink.add;
  Stream<String> get onChangeNameText => _nameTextController.stream;
  String get getName => _nameTextController.value;

  Function(String) get setPriceNum => _priceNumberController.sink.add;
  Stream<String> get onChangePriceNum => _priceNumberController.stream;
  String get getPrice => _priceNumberController.value;

  Function(String) get setNextTime => _nextTimeController.sink.add;
  Stream<String> get onChangeNextTime => _nextTimeController.stream;
  String get getNextTime => _nextTimeController.value;

  Function(String) get setCycle => _cycleController.sink.add;
  Stream<String> get onChangeCycle => _cycleController.stream;
  String get getCycle => _cycleController.value;

  void dispose() {
    _nameTextController.close();
    _priceNumberController.close();
    _nextTimeController.close();
    _cycleController.close();
  }
}
