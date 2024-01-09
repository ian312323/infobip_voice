import Foundation
import InfobipRTC


class RTCVideoView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var streamId: String?
    private var videoView: UIView?
    private var plugin: InfobipPlugin

    init(
            frame: CGRect,
            viewIdentifier viewId: Int64,
            arguments args: Any?,
            binaryMessenger messenger: FlutterBinaryMessenger?,
            plugin: InfobipPlugin
    ) {
        streamId = (args as AnyObject)["streamId"] as? String
        self.plugin = plugin

        _view = UIView()

        super.init()
        createNativeView(view: _view, frame: frame)
    }

    func createNativeView(
            view _view: UIView,
            frame: CGRect
    ){
//        if let streamId = streamId as String? {
//            let videoView = InfobipRTCFactory.videoView(frame: frame, contentMode: .scaleAspectFit)
//            videoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            if streamId == "local" {
//                InfobipRTC.getActiveCall()?.localVideoTrack()?.addRenderer(videoView)
//            } else {
//                InfobipRTC.getActiveCall()?.remoteVideoTrack()?.addRenderer(videoView)
//            }
//
//            self.videoView = videoView
//
//            plugin.setView(streamId: streamId, rtcVideoView: self)
//
//            _view.addSubview(videoView)
//        }
    }

    func view() -> UIView {
        _view
    }

    func attachTrack(_ track: VideoTrack?) {
        if let videoView = videoView {
            track?.addRenderer(videoView)
        }
    }

    func release() {
    }
}
