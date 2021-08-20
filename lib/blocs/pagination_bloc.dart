import 'package:rxdart/rxdart.dart';

class PaginationBloc {
  final _pagenationController = BehaviorSubject<int>();

  Function(int) get go => _pagenationController.sink.add;
  Stream<int> get currentPage => _pagenationController.stream;

  PaginationBloc() {
    go(0);
  }

  void dispose() {
    _pagenationController.close();
  }
}
