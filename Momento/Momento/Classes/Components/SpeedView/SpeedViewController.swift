//
//  SpeedViewController.swift
//  Momento
//
//  Created by Александр on 05.11.2021.
//

import UIKit

class SpeedViewController: BottomPopupViewController {

    var didChangeRate: ((Float) -> Void)?
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var sliderView: UISlider!
    
    
    override var popupHeight: CGFloat {
//        let height = UIScreen.main.bounds.height
        return 254
    }
    
    override var popupTopCornerRadius: CGFloat {
        return 14
    }
    
    var rate: Float
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            self.saveButton.layer.cornerRadius = 10
            self.saveButton.layer.masksToBounds = true
        }
    }
    
    init(rate: Float) {
        self.rate = rate
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.frame.height)
        self.valueLabel.text = "\(Int(self.rate * 100))%"
        self.sliderView.setValue(self.rate, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onDidSliderChangeValur(_ sender: UISlider) {
        self.rate = sender.value
        self.didChangeRate?(self.rate)
        self.valueLabel.text = "\(Int(self.rate * 100))%"
    }
    
    @IBAction func onDidDismissTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
