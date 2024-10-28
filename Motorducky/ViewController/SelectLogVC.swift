//
//  SelectLogVC.swift
//  Motorducky
//
//  Created by Milan Chhodavadiya on 23/10/24.
//

import UIKit

class SelectLogVC: UIViewController {

    @IBOutlet weak var btnDuckyBuildLog: UIButton!
    @IBOutlet weak var btnBuildLog: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        self.btnBuildLog.layer.cornerRadius = 10
        self.btnDuckyBuildLog.layer.cornerRadius = 10
    }
    
    @IBAction func btnBuildLog_Clicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BuildLogVC") as! BuildLogVC
        vc.url = "https://motorducky.com/buildlog.txt"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnQuackBuildLog_Clicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BuildLogVC") as! BuildLogVC
        vc.url = "https://motorducky.com/talkingduck_buildlog.txt"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
