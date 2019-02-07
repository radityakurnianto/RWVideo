//
//  RWVideo.swift
//  Pods-RWVideo_Example
//
//  Created by Raditya Kurnianto on 2/6/19.
//

import UIKit
import AVKit

open class RWVideo: UIViewController {
    fileprivate var avplayer: AVPlayer
    fileprivate var avplayerLayer: AVPlayerLayer
    fileprivate var avplayerItem: AVPlayerItem?
    fileprivate var videoURL: URL!
    
    fileprivate let VideoStatus = "status"
    fileprivate let BufferEmpty = "playbackBufferEmpty"
    fileprivate let KeepUp = "playbackLikelyToKeepUp"
    
    open var didTapPlay:(()->Void)?
    open var didTapPause:(()->Void)?
    
    // MARK: Init
    public convenience init() {
        self.init()
    }
    
    public init(videoUrl: URL) {
        self.videoURL = videoUrl
        self.avplayer = AVPlayer(url: self.videoURL)
        self.avplayerLayer = AVPlayerLayer(player: self.avplayer)
        self.avplayerLayer.videoGravity = .resizeAspectFill
        self.avplayerItem = self.avplayer.currentItem
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.layer .insertSublayer(self.avplayerLayer, at: 0)
        addObserver()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    // MARK: Player command
    public func play() {
        self.avplayer.play()
    }
    
    public func pause() {
        self.avplayer.pause()
    }
    
    // MARK: Observer
    fileprivate func addObserver() {
        guard let item = self.avplayerItem else { return }
        item.addObserver(self, forKeyPath: VideoStatus, options: .new, context: nil)
        item.addObserver(self, forKeyPath: BufferEmpty, options: .new, context: nil)
        item.addObserver(self, forKeyPath: KeepUp, options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playbackFinish), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: item)
    }
    
    fileprivate func removeObserver() {
        guard let item = avplayerItem else { return }
        item.removeObserver(self, forKeyPath: VideoStatus)
        item.removeObserver(self, forKeyPath: BufferEmpty)
        item.removeObserver(self, forKeyPath: KeepUp)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: item)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let item = avplayerItem else { return }
        guard let keypath = keyPath else { return }
        
        if keypath.elementsEqual(VideoStatus) {
            switch (item.status) {
            case .unknown :
                break
            case .failed:
                break
            case .readyToPlay:
                break
            }
        }
        
        if keypath.elementsEqual(BufferEmpty) && item.isPlaybackBufferEmpty {
            
        }
        
        if keypath.elementsEqual(KeepUp) && item.isPlaybackLikelyToKeepUp {
            
        }
    }
    
    @objc fileprivate func playbackFinish(notification: Notification) {
        
    }
}
