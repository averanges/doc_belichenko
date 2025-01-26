import 'dart:collection';

///Mixin for processing a [Queue] of functions.
mixin QueueProcessorMixin {
  final Queue<Future Function()> _functionQueue = Queue();
  bool _isProcessingQueue = false;

  ///Uses to handle multiple drag-inside [Future]s at the same time.
  Future<void> processQueue() async {
    if (_isProcessingQueue) return;
    _isProcessingQueue = true;

    while (_functionQueue.isNotEmpty) {
      final function = _functionQueue.removeFirst();
      await function();
    }

    _isProcessingQueue = false;
  }

  void addFunctionToQueue(Future Function() function) {
    _functionQueue.add(function);
  }

  void clearQueue() {
    _isProcessingQueue = false;
    _functionQueue.clear();
  }
}
