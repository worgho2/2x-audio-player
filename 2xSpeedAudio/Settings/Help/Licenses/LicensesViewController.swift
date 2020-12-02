//
//  LicensesViewController.swift
//  2xSpeedAudio
//
//  Created by otavio on 15/11/20.
//

import UIKit

class LicensesViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildText()
        
    }
    
    func buildText() {
        self.textView.text = """
        Licenses:

        Tutorial Music: https://www.bensound.com

        --
        """
    }
    
}
