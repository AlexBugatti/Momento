//
//  RepeatViewController.swift
//  Momento
//
//  Created by Александр on 05.11.2021.
//

import UIKit

class RepeatViewController: BottomPopupViewController {

    override var popupHeight: CGFloat {
        return 262
    }
    
    override var popupTopCornerRadius: CGFloat {
        return 14
    }
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            self.saveButton.layer.cornerRadius = 10
            self.saveButton.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
