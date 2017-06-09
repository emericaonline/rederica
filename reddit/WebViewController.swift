//
//  WebViewController.swift
//  reddit
//
//  Created by Jonathan Tran on 2/8/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var url: String
    
    init(url: String){
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        let webView = UIWebView(frame: view.frame)
        webView.loadRequest(URLRequest(url: URL(string: url)!))
        webView.scalesPageToFit = true
        view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
