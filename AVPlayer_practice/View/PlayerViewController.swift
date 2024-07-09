//
//  PlayerViewController.swift
//  AVPlayer_practice
//
//  Created by 최주리 on 7/9/24.
//

import AVFoundation
import SnapKit
import UIKit

final class PlayerViewController: BaseViewController {
    
    private var player = AVPlayer()
    
    private var contentStackView = UIStackView()
    private var timeSlider = UISlider()
    private var labelStackView = UIStackView()
    private var currentTimeLabel = UILabel()
    private var totalTimeLabel = UILabel()
    private var playButton = UIButton()
    
    private var totalTime: Float64 = 0 {
        didSet {
            totalTimeLabel.text = changeFloatTimeToLabel(totalTime)
        }
    }
    private var currentTime: Float64 = 0 {
        didSet {
            currentTimeLabel.text = changeFloatTimeToLabel(currentTime)
            timeSlider.value = Float(currentTime / totalTime)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPeriodicTimeObserver()
    }
    
    override func setAttribute() {
        
        player = {
            guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else {
                print("Failed to load url")
                fatalError()
            }
            print("load success")
            let player = AVPlayer()
            let playerItem = AVPlayerItem(url: url)
            // 한번에 하나씩만 다룰 수 있음
            player.replaceCurrentItem(with: playerItem)
            
            return player
        }()
        
        contentStackView = {
           let stackView = UIStackView()
            stackView.axis = .vertical
            
            return stackView
        }()
        
        timeSlider = {
           let slider = UISlider()
            slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            return slider
        }()
        
        labelStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            return stackView
        }()
        
        currentTimeLabel = {
           let label = UILabel()
            label.text = "00:00"
            return label
        }()
        
        totalTimeLabel = {
           let label = UILabel()
            label.text = "00:00"
            return label
        }()
        
        playButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "play.fill"), for: .normal)
            button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
            return button
        }()
    }
    
    override func addView() {
        view.addSubview(contentStackView)
        
        [timeSlider, labelStackView, playButton].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        [currentTimeLabel, totalTimeLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(safeArea).inset(20)
        }
        
    }
    
    @objc
    private func playButtonTapped() {
        switch player.timeControlStatus {
        case .paused:
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .playing:
            player.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        default:
            break
        }
    }
    
    @objc
    private func sliderValueChanged() {
        currentTime = Float64(timeSlider.value) * totalTime
        player.seek(to: CMTimeMakeWithSeconds(currentTime, preferredTimescale: Int32(NSEC_PER_SEC)))

    }
    
    // 현재까지 재생된 시간 정보를 획득
    private func addPeriodicTimeObserver() {
        //  1초마다 데이터를 받기
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] currentTime in
            // CMTime인스턴스를 CMTimeGetSeconds()안에 넣어서 Float64 타입으로 획득
            let currentTimeFloat = CMTimeGetSeconds(currentTime)
            let totalTimeFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            
            guard
                !currentTimeFloat.isNaN,
                !currentTimeFloat.isInfinite,
                !totalTimeFloat.isNaN,
                !totalTimeFloat.isInfinite else { return }
            
            self?.totalTime = totalTimeFloat
            self?.currentTime = currentTimeFloat
        })
    }
    
    private func changeFloatTimeToLabel(_ time: Float64) -> String {
        let timeInt = Int(time)
        let minute = Int(timeInt / 60)
        let seconds = Int(timeInt % 60)
        
        return String(format: "%02d:%02d", minute, seconds)
    }
}
