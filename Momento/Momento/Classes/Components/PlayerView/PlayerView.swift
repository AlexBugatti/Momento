//
//  PlayerView.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import UIKit
import AVFoundation
//import PryntTrimmerView

enum Mode {
    case none
    case duration
    case effect
    case sticker
}

class PlayerView: NibView {

    var didDismiss: (() -> Void)?
    var didSave: ((URL) -> Void)?
    
    private var url: URL?
    var mode: Mode = .none {
        didSet {
            self.update()
        }
    }
    
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            self.dismissButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            self.saveButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var contentView: UIView!
    var croppView: VideoCropView! {
        didSet {
            self.croppView.backgroundColor = .clear
        }
    }
    
    init(url: URL?) {
        self.url = url
        super.init(frame: .zero)
        
//        self.setVideo(url: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var playButtonStatus: Bool = false
    var asset: AVAsset?
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if let playRate = self.avPlayer?.rate {
                let img = playRate == 0.0 ? UIImage(named: "play_button") : UIImage(named: "pause") 
                self.rateButton.setImage(img, for: .normal)
                if playRate == 0.0 {
                    print("playback paused")
                } else {
                    print("playback started")
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        croppView?.layoutIfNeeded()
        croppView?.setAspectRatio(CGSize(width: self.frame.width,
                                        height: self.frame.height), animated: false)
        self.avPlayerLayer?.frame = self.contentView.bounds
    }
    
    func dismiss() {
        self.avPlayer?.pause()
        self.avPlayer = nil
        self.url = nil
        self.avPlayerLayer?.removeFromSuperlayer()
    }
    
    func setVideo(url: URL) {
        let videoURL = url
        self.url = url
        self.avPlayer = AVPlayer(url: videoURL)
        self.avPlayer?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
        self.avPlayerLayer?.videoGravity = .resizeAspectFill
        self.avPlayerLayer?.frame = self.contentView.bounds
        self.contentView.layer.addSublayer(self.avPlayerLayer!)
        
//        self.croppView?.removeFromSuperview()
//        croppView = VideoCropView()
//        contentView.addSubview(croppView)
//        croppView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        let asset = AVAsset.init(url: url)
//        croppView.asset = asset
//        croppView.player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//        croppView.layoutIfNeeded()
//        croppView.setAspectRatio(CGSize(width: self.contentView.frame.width,
//                                        height: self.contentView.frame.height), animated: false)
//        self.avPlayerLayer?.isHidden = true
        self.croppView?.isHidden = true
//        self.controlsView.isHidden = false
//        self.playerView.isHidden = false
//        self.bigImageView.image = nil
//        self.smallImageView.isHidden = true
    }
    
    func setCroppVideo(url: URL) {
        let videoURL = url
        self.url = url
//        self.avPlayer = AVPlayer(url: videoURL)
//        self.avPlayer?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
//        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
//        self.avPlayerLayer?.videoGravity = .resizeAspectFill
//        self.avPlayerLayer?.frame = self.contentView.bounds
//        self.contentView.layer.addSublayer(self.avPlayerLayer!)
        
        self.croppView?.removeFromSuperview()
        croppView = VideoCropView()
        contentView.addSubview(croppView)
        croppView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if asset == nil {
            asset = AVAsset.init(url: url)
        }
//        let asset = AVAsset.init(url: url)
        croppView.asset = asset
        croppView.player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        croppView.layoutIfNeeded()
        croppView.setAspectRatio(CGSize(width: self.contentView.frame.width,
                                        height: self.contentView.frame.height), animated: false)
        self.avPlayerLayer?.isHidden = true
        
//        self.controlsView.isHidden = false
//        self.playerView.isHidden = false
//        self.bigImageView.image = nil
//        self.smallImageView.isHidden = true
    }
    
    @IBAction func onDidDismisTapped(_ sender: Any) {
        self.didDismiss?()
    }
    
    @IBAction func onDidSaveTapped(_ sender: Any) {
        if let url = url {
            self.didSave?(url)
        }
    }
    
    @IBAction func onDidPlayTapped(_ sender: Any) {
        if self.playButtonStatus == false {
            self.croppView?.player?.play()
            self.avPlayer?.play()
            self.playButtonStatus = true
        } else {
            self.croppView?.player?.pause()
            self.avPlayer?.pause()
            self.playButtonStatus = false
        }
        
    }
    
    func update() {
        
        switch mode {
        case .none, .sticker, .effect:
            break
            self.saveButton.setImage(UIImage(named: "save"), for: .normal)
            self.setVideo(url: url!)
        case .duration:
            self.saveButton.setImage(UIImage(named: "ok"), for: .normal)
            self.setCroppVideo(url: url!)
        default:
            break
        }
        
    }
    
//    func setDuration() {
//
//    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
