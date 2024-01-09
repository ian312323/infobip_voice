import Foundation

class FlutterModel {
    enum CameraOrientation: String, Codable {
        case front = "FRONT"
        case back = "BACK"
    }
    
    struct Endpoint: Codable{
        let type: EndpointType
        let identifier: String
        let displayIdentifier: String?
    }
    
    enum EndpointType: String, Codable{
        case webrtc = "webrtc"
        case sip = "sip"
        case phone = "phone"
        case viber = "viber"
    }
    
    enum CallStatus: String, Codable {
        case initializing = "INITIALIZING"
        case calling = "CALLING"
        case ringing = "RINGING"
        case connecting = "CONNECTING"
        case established = "ESTABLISHED"
        case finishing = "FINISHING"
        case finished = "FINISHED"
    }
    
    struct VideoOptions: Codable {
        let cameraOrientation: CameraOrientation?
    }
    
    struct RecordingOptions: Codable {
        let audio: Bool?
        let video: Bool?
    }
    
    struct CallOptions: Codable {
        let video: Bool?
        let recordingOptions: RecordingOptions?
        let videoOptions: VideoOptions?
        // TODO This isn't possible, see:
        //  https://stackoverflow.com/questions/60171453/codable-string-any-dictionary
        //  let customData: [String: Any]?
    }
    
    struct User: Codable {
        let identity: String
        let displayName: String?
    }
    
    struct Call: Codable {
        let id: String
        let status: CallStatus
        let muted: Bool
        let speakerphone: Bool
        let duration: Int
        let startTime: Date?
        let establishTime: Date?
        let endTime: Date?
        let source: Endpoint
        let destination: Endpoint
    }
    
    struct CallHangupEvent: Codable {
        let id: Int
        let name: String?
        let description: String?
    }
    
    struct CallEstablishedEvent: Codable {
        let hasLocalVideo: Bool
        let hasRemoteVideo: Bool
    }
    
    struct CallUpdatedEvent: Codable {
        let hasLocalVideo: Bool
        let hasRemoteVideo: Bool
    }
    
    struct CallErrorEvent: Codable {
        let name: String?
        let description: String?
    }
}


