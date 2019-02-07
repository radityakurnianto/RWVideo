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
    
    fileprivate lazy var videoView: UIView = { [unowned self] in
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }()
    
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
        self.avplayerItem = self.avplayer.currentItem
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        view.backgroundColor = .black
        view.addSubview(videoView)
        videoViewPotraitConstraint()
        videoView.layer.insertSublayer(self.avplayerLayer, at: 0)
        
        addObserver()
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        removeObserver()
    }
    
    
    
    // MARK: Constraint
    fileprivate func videoViewPotraitConstraint() -> Void {
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        videoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //        videoView.topAnchor.constraint(equalTo: view.topAnchor)
        videoView.leftAnchor.constraint(equalTo: view.leftAnchor)
        videoView.rightAnchor.constraint(equalTo: view.rightAnchor)
        videoView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9.0/16.0).isActive = true
//        videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    }
    
    func videoViewLandscapeConstraint() -> Void {
        //
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
                print("player_unknown")
                break
            case .failed:
                print("player_failed")
                break
            case .readyToPlay:
                self.play()
                print("player_ready_toPlay")
                break
            }
        }
        
        if keypath.elementsEqual(BufferEmpty) && item.isPlaybackBufferEmpty {
            
        }
        
        if keypath.elementsEqual(KeepUp) && item.isPlaybackLikelyToKeepUp {
            
        }
    }
    
    @objc fileprivate func playbackFinish(notification: Notification) {
        print("player_finished")
    }
}
