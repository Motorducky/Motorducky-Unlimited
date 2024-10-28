//
//  SettingsVC.swift
//  Motorducky
//
//  Created by Milan Chhodavadiya on 23/10/24.
//

import UIKit
import AVKit
import AVFoundation

class SettingsVC: UIViewController {

    @IBOutlet weak var viewPicture: UIView!
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var viewCoordinates: UIView!
    @IBOutlet weak var viewChatGPT: UIView!
    @IBOutlet weak var viewWebhook: UIView!
    @IBOutlet weak var viewGeo: UIView!
    
    var playerViewController: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        self.viewPicture.layer.cornerRadius = 10
        self.viewText.layer.cornerRadius = 10
        self.viewCoordinates.layer.cornerRadius = 10
        self.viewChatGPT.layer.cornerRadius = 10
        self.viewWebhook.layer.cornerRadius = 10
        self.viewGeo.layer.cornerRadius = 10
    }
    
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGeofenceRanges_Clicked(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnWebhook_Clicked(_ sender: UIButton) {
        // Get the file URL for the video in the bundle
        guard let filePath = Bundle.main.path(forResource: "sample", ofType: "mp4") else {
            print("Video file not found in bundle.")
            return
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        let player = AVPlayer(url: fileURL)
        
        // Initialize the AVPlayerViewController
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.modalPresentationStyle = .fullScreen
        
        // Present the player view in landscape
        present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    @IBAction func btnChatGPTPrompts_Clicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnCoordinatesDuck_Clicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnBuildlogText_Clicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnBuildLogPicture_Clicked(_ sender: UIButton) {
        
    }
}
