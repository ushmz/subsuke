import 'package:rxdart/rxdart.dart';

class EditScreenBloc {
  final _nameTextController = BehaviorSubject<String>();
  final _priceNumberController = BehaviorSubject<int>();
  final _nextTimeController = BehaviorSubject<String>();
  final _cycleController = BehaviorSubject<String>();

  Function(String) get setNameText => _nameTextController.sink.add;
  Stream<String> get onChangeNameText => _nameTextController.stream;

  Function(int) get setPriceNum => _priceNumberController.sink.add;
  Stream<int> get onChangePriceNum => _priceNumberController.stream;

  Function(String) get setNextTime => _nextTimeController.sink.add;
  Stream<String> get onChangeNextTime => _nextTimeController.stream;

  Function(String) get setCycle => _cycleController.sink.add;
  Stream<String> get onChangeCycle => _cycleController.stream;

  void dispose() {
    _nameTextController.close();
    _priceNumberController.close();
    _nextTimeController.close();
    _cycleController.close();
  }
}
