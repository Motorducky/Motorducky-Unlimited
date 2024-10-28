//
//  VideoPlayerVC.swift
//  Motorducky
//
//  Created by Milan Chhodavadiya on 24/10/24.
//

import UIKit
import AVKit
import AVFoundation

// https://youtu.be/TFIzXZJmXq8?si=zjUvPoNTStltAHs8

class VideoPlayerVC: UIViewController {
    
    var playerViewController: AVPlayerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Ensure this ViewController only supports landscape
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
}
