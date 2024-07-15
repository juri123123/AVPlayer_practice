//
//  PIPViewController.swift
//  AVPlayer_practice
//
//  Created by 최주리 on 7/15/24.
//

import AVKit
import SnapKit
import UIKit

final class PIPViewController: BaseViewController {
    private let playerLayer = AVPlayerLayer()
    private let player = AVPlayer()
    private lazy var button = UIButton()
    private lazy var pipController: AVPictureInPictureController? = AVPictureInPictureController()
    
    override func viewDidLoad() {
        setPip()
    }
    
    override func setAttribute() {
        
        button = {
           let button = UIButton()
            button.setTitle("pip 활성화", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            return button
        }()
    }
    override func addView() {
        view.addSubview(button)
    }
    override func setLayout() {
        button.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
    }
    
    private func setPip() {
        guard let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else { return }
        
        let asset = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: asset)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
        player.play()
        
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    @objc func buttonTapped() {
        guard let isActive = pipController?.isPictureInPictureActive else { return }
        isActive ? pipController?.stopPictureInPicture() : pipController?.startPictureInPicture()
        isActive ? button.setTitle("비활성화", for: .normal) : button.setTitle("활성화 ", for: .normal)
    }
}

extension PIPViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("willStart")
    }
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("didStart")
    }
    
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: any Error) {
        print("fail")
    }
    
    func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("willStop")
    }
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("didStop")
    }
    
    // 작아진 Pip 화면을 다시 키울 때
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        print("restore")
    }
}

