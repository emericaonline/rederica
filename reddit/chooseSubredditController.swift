//
//  chooseSubredditController.swift
//  reddit
//
//  Created by Jonathan Tran on 2/16/17.
//  Copyright © 2017 Jonathan Tran. All rights reserved.
//

import UIKit

class chooseSubredditController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textInput = UITextField()
        textInput.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textInput)
        
        view.addConstraintsWithFormat(format: "V:|-[v0]-|", views: textInput)
        view.addConstraintsWithFormat(format: "H:|-[v0]-|", views: textInput)
        
       
        
        // Do any additional setup after loading the view.
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
