//
//  ToolsView.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import UIKit
import AVFoundation

class ToolsView: NibView, TimelinePlayStatusReceiver {
    
    var didTrimTapped: (() -> Void)?
    var didStickerTapped: (() -> Void)?
    var didSpeedTapped: (() -> Void)?
    var didRepeatTapped: (() -> Void)?
    
    func videoTimelineStopped() {
        //
    }
    
    func videoTimelineMoved() {
        //
    }
    
    func videoTimelineTrimChanged() {
        //
    }
    

    @IBOutlet weak var timelineView: UIView!
    @IBOutlet weak var effectView: UIView!
    
    @IBOutlet weak var containerTimeline: UIView!
    private var videoTimelineView: VideoTimelineView!
    
    @IBOutlet weak var trimButton: UIButton!
    @IBOutlet weak var featureButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var stickButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        common()
    }
    
    var url: URL?
    
    func setup(url: URL, player: AVPlayer) {
        self.url = url
        self.configure(player: player)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if let playRate = self.videoTimelineView.player?.rate {
                let img = playRate == 0.0 ? UIImage(named: "play_button") : UIImage(named: "pause")
//                self.rateButton.setImage(img, for: .normal)
                if playRate == 0.0 {
                    print("playback paused23234")
                } else {
                    print("playback started6456456")
                }
            }
        }
    }
    
    func common() {
        self.hideAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.videoTimelineView?.frame = layout()
    }
    
    func configure(player: AVPlayer) {
        
        if let url = url {
            let asset = AVAsset.init(url: url)
            videoTimelineView?.removeFromSuperview()
            videoTimelineView = VideoTimelineView()
            videoTimelineView.frame = layout()
            videoTimelineView.new(asset: asset)
            videoTimelineView.player = player
            player.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
            videoTimelineView.playStatusReceiver = self
            
            videoTimelineView.repeatOn = true
            videoTimelineView.setTrimIsEnabled(true)
            videoTimelineView.setTrimmerIsHidden(false)
            containerTimeline.addSubview(videoTimelineView)
        }
    }
    
    func layout() -> CGRect {
        let timeline = CGRect(x: 0, y:0, width:containerTimeline.frame.size.width, height:containerTimeline.frame.size.height)
        
        return timeline
    }
    
    func hideAll() {
        
        self.timelineView.isHidden = true
        self.effectView.isHidden = true
    }
    
    func showTimelineView() {
        UIView.animate(withDuration: 0.2) {
            self.effectView.isHidden = true
            self.timelineView.isHidden = false
        }
    }
    
    func showEffectView() {
        UIView.animate(withDuration: 0.2) {
            self.effectView.isHidden = false
            self.timelineView.isHidden = true
        }
    }
    
    
    @IBAction func onDidTrimTapped(_ sender: UIButton) {
        self.didTrimTapped?()
        self.showTimelineView()
    }
    
    @IBAction func onDidEffectTapped(_ sender: Any) {
        self.showEffectView()
    }
    
    @IBAction func onDidStickerTapped(_ sender: Any) {
        self.didStickerTapped?()
    }
    
    @IBAction func onDidRepeatTapped(_ sender: Any) {
        self.didRepeatTapped?()
    }
    
    @IBAction func onDidSpeedTapped(_ sender: Any) {
        self.didSpeedTapped?()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
