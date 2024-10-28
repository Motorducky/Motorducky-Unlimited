//
//  BuildLogVC.swift
//  Motorducky
//
//  Created by Milan Chhodavadiya on 23/10/24.
//

import UIKit

class BuildLogVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var url = "https://motorducky.com/buildlog.txt"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchText()
    }
    
    private func fetchText() {
        guard let url = URL(string: self.url) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            if let text = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.textView.text = text
                }
            }
        }
        task.resume()
    }
    
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
