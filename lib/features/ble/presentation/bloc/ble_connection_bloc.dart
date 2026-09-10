import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/connect_device_usecase.dart';
import '../../domain/usecases/disconnect_device_usecase.dart';
import '../../domain/usecases/discover_services_usecase.dart';
import 'ble_connection_event.dart';
import 'ble_connection_state.dart';

class BleConnectionBloc
    extends Bloc<BleConnectionEvent, BleConnectionState> {
  final ConnectDeviceUseCase connectDeviceUseCase;
  final DisconnectDeviceUseCase disconnectDeviceUseCase;
  final DiscoverServicesUseCase discoverServicesUseCase;

  BleConnectionBloc({
    required this.connectDeviceUseCase,
    required this.disconnectDeviceUseCase,
    required this.discoverServicesUseCase,
  }) : super(BleConnectionInitial()) {
    on<ConnectDeviceEvent>(_onConnect);
    on<DisconnectDeviceEvent>(_onDisconnect);
    on<DiscoverServicesEvent>(_onDiscoverServices);
  }

  Future<void> _onConnect(
      ConnectDeviceEvent event,
      Emitter<BleConnectionState> emit,
      ) async {
    emit(BleConnectionConnecting(event.deviceId));
    try {
      final device = await connectDeviceUseCase(event.deviceId);
      emit(BleConnectionConnected(device));
      // Auto-discover services after connecting
      add(DiscoverServicesEvent(event.deviceId));
    } catch (e) {
      emit(BleConnectionError('Connection failed: ${e.toString()}'));
    }
  }

  Future<void> _onDisconnect(
      DisconnectDeviceEvent event,
      Emitter<BleConnectionState> emit,
      ) async {
    try {
      await disconnectDeviceUseCase(event.deviceId);
      emit(BleConnectionDisconnected());
    } catch (e) {
      emit(BleConnectionError('Disconnect failed: ${e.toString()}'));
    }
  }

  Future<void> _onDiscoverServices(
      DiscoverServicesEvent event,
      Emitter<BleConnectionState> emit,
      ) async {
    final currentState = state;
    if (currentState is BleConnectionConnected) {
      emit(BleConnectionDiscovering(currentState.device));
      try {
        final characteristics =
        await discoverServicesUseCase(event.deviceId);
        emit(BleConnectionServicesDiscovered(
          currentState.device,
          characteristics,
        ));
      } catch (e) {
        emit(BleConnectionError(
            'Service discovery failed: ${e.toString()}'));
      }
    }
  }
}