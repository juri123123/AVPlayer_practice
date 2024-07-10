//
//  VideoPlayViewController.swift
//  AVPlayer_practice
//
//  Created by 최주리 on 7/10/24.
//

import AVFoundation
import SnapKit
import UIKit

final class VideoPlayViewController: BaseViewController {
    private var videoView = VideoView(url: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setAttribute() {
        videoView = {
            let view = VideoView(url: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")
            return view
        }()
    }
    override func addView() {
        view.addSubview(videoView)
    }
    override func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        videoView.snp.makeConstraints {
            $0.edges.equalTo(safeArea).inset(10)
        }
    }
}

