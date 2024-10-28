//
//  WebVC.swift
//  Motorducky
//
//  Created by Milan Chhodavadiya on 23/10/24.
//

import UIKit
import WebKit

class WebVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        webView.load(URLRequest(url: URL(string: "https://motorducky.com/build_images/index.php") as URL))
        webView.load(NSURLRequest(url: NSURL(string: "https://motorducky.com/build_images/index.php")! as URL) as URLRequest)

    }

}
