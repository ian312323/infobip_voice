import Foundation
import InfobipRTC

extension CameraOrientation {
    func toFlutterEnum() -> FlutterModel.CameraOrientation {
        switch (self) {
        case .front:
            return .front
        case .back:
            return .back
        default:
            return .front
        }
    }
}

extension Encodable {
    func toJsonData() -> Data? {
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            return try encoder.encode(self)
        } catch {
            return nil
        }
    }
    
    func toJsonString() -> String? {
        guard let data = toJsonData() else {
            return nil
        }
        return String(decoding: data, as: UTF8.self)
    }
}

//public extension OutgoingCall {
//    func toFlutterModel() -> FlutterModel.Call {
//        FlutterModel.Call(
//                id: id(),
//                correlationId: correlationId(),
//                callOptions: options.toFlutterModel(),
//                status: status.toFlutterModel(),
//                hasLocalVideo: hasLocalVideo(),
//                hasRemoteVideo: hasRemoteVideo(),
//                hasScreenShare: hasScreenShare(),
//                muted: muted(),
//                speakerphone: speakerphone(),
//                duration: duration(),
//                startTime: startTime(),
//                establishTime: establishTime(),
//                endTime: endTime(),
//                source: source().toFlutterModel(),
//                destination: destination().toFlutterModel(),
//                cameraOrientation: cameraOrientation().toFlutterModel(),
//                recordingOptions: recordingOptions().toFlutterModel()
//        )
//    }
//}

extension CallStatus {
    func toFlutterModel() -> FlutterModel.CallStatus {
        switch (self) {
        case .initializing:
            return .initializing
        case .calling:
            return .calling
        case .ringing:
            return .ringing
        case .established:
            return .established
        case .finishing:
            return .finishing
        case .finished:
            return .finished
        case .initialized:
            return .established
        case .connecting:
            return .connecting
        @unknown default:
            return .initializing
        }
    }
}



//extension RTCUser {
//    func toFlutterModel() -> FlutterModel.User {
//        FlutterModel.User(
//            identity: identity, displayName: displayName
//        )
//    }
//}
//

extension Endpoint{
    func toFlutterModel() -> FlutterModel.Endpoint{
        FlutterModel.Endpoint(type: type.toFlutterModel(), identifier: identifier(), displayIdentifier: displayIdentifier())
    }
}

extension EndpointType{
    func toFlutterModel() -> FlutterModel.EndpointType{
        switch self{
        case .phone:
            FlutterModel.EndpointType.phone
        case .webrtc:
            FlutterModel.EndpointType.webrtc
        case .sip:
            FlutterModel.EndpointType.sip
        case .viber:
            FlutterModel.EndpointType.viber
        @unknown default:
            FlutterModel.EndpointType.sip
        }
        
    }
}
extension Call {
    func toFlutterModel() -> FlutterModel.Call {
        FlutterModel.Call(
            id: id(),
            status: status.toFlutterModel(),
            muted: muted(),
            speakerphone: speakerphone(),
            duration: duration(),
            startTime: startTime(),
            establishTime: establishTime(),
            endTime: endTime(),
            source: source().toFlutterModel(),
            destination: destination().toFlutterModel()
        )
    }
}

extension CallHangupEvent {
    func toFlutterModel() -> FlutterModel.CallHangupEvent {
        FlutterModel.CallHangupEvent(id: errorCode.id, name: errorCode.name, description: errorCode.description)
    }
}

//extension CallEstablishedEvent {
//    func toFlutterModel() -> FlutterModel.CallEstablishedEvent {
//        FlutterModel.CallEstablishedEvent(
//
//        )
//    }
//}

//extension CallUpdatedEvent {
//    func toFlutterModel() -> FlutterModel.CallUpdatedEvent {
//        FlutterModel.CallUpdatedEvent(
//                hasLocalVideo: localVideoTrack != nil,
//                hasRemoteVideo: remoteVideoTrack != nil
//        )
//    }
//}
//
extension CallError {
    func toFlutterModel() -> FlutterModel.CallErrorEvent {
        FlutterModel.CallErrorEvent(
            name: localizedDescription,
            description: errorDescription
        )
    }
}
