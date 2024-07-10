//
//  VideoView.swift
//  AVPlayer_practice
//
//  Created by 최주리 on 7/10/24.
//

import AVFoundation
import UIKit

final class VideoView: UIView {
    private var player = AVPlayer()
    private var playerLayer: AVPlayerLayer?
    private let url: String
    
    private var totalTime: Float64 = 0
    private var currentTime: Float64 = 0 {
        didSet {
            slider.value = Float(currentTime / totalTime)
        }
    }
    
    private var videoContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var slider: UISlider = {
       let slider = UISlider()
        
        return slider
    }()
    
    init(url: String) {
        self.url = url
        super.init(frame: .zero)
        
        guard let url = URL(string: url) else { return }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        let layer = AVPlayerLayer(player: player)
        layer.frame = self.videoContentView.bounds
        self.playerLayer = layer
        videoContentView.layer.addSublayer(self.playerLayer ?? layer)
        player.play()
        
        if player.currentItem?.status == .readyToPlay {
            slider.minimumValue = 0
            slider.maximumValue = Float(CMTimeGetSeconds(item.duration))
        }
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let currentTiemFloat = CMTimeGetSeconds(time)
            let totalTimeFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            self?.currentTime = currentTiemFloat
            self?.totalTime = totalTimeFloat
            
            //print(self?.currentTime, self?.totalTime)
        }
        
        [videoContentView, slider].forEach {
            self.addSubview($0)
        }
        
        videoContentView.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.horizontalEdges.equalTo(self)
            $0.height.equalTo(250)
        }
        slider.snp.makeConstraints {
            $0.top.equalTo(videoContentView.snp.bottom)
            $0.horizontalEdges.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // AVPlayerLayer의 frame 사이즈를 정해주어야 하므로, layoutSubviews에서 frame 정의
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer?.frame = videoContentView.bounds
    }
    
    @objc
    private func sliderValueChanged() {
        currentTime = Float64(slider.value) * totalTime
        player.seek(to: CMTime(seconds: currentTime, preferredTimescale: Int32(NSEC_PER_SEC)))
    }
}
