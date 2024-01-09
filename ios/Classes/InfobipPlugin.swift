import Foundation
import InfobipRTC

public protocol InfobipPlugin {
    func setView(streamId: String)
    func setTrack(streamId: String, track: VideoTrack?)
    func clearViews()
    func emitEvent(event: String, data: Codable?)
}
