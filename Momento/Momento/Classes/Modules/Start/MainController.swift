//
//  MainController.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import UIKit
import SnapKit
import MBProgressHUD

class MainController: UIViewController {

    var viewModel: MainViewModelInterface
    
    var imagePicker: ImagePicker?
    var videoURL: URL? {
        didSet {
            if let url = videoURL {
//                let data = try! Data(contentsOf: url)
//                self.sizeLabel.text = "Size of Video: \(CGFloat(data.count) / 1000000) Megabytes"
//
//                containerImageView.setVideo(url: url)
            }
        }
    }
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var toolsView: ToolsView!
    
    @IBOutlet weak var backView: UIView! {
        didSet {
            self.backView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            self.backView.layer.masksToBounds = true
            self.backView.layer.cornerRadius = 24
        }
    }
    @IBOutlet weak var pickButton: UIButton! {
        didSet {
            self.pickButton.layer.cornerRadius = 10
            self.pickButton.layer.masksToBounds = true
        }
    }
//    @IBOutlet weak var toolsStackView: UIStackView!
    
    
    init(viewModel: MainViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self, types: [.video])
        self.playerView.didDismiss = {
            self.dismissAlert()
        }
        self.playerView.didSave = { url in
            self.viewModel.save(url: url)
        }
        
        viewModel.didHideLoader = {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        viewModel.didShowLoader = {
            DispatchQueue.main.async {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.show(animated: true)
            }
        }
        
        refresh()
        
        toolsView.didTrimTapped = {
            self.playerView.mode = .duration
        }
        toolsView.didStickerTapped = {
            let vc = StickersController.init(nibName: nil, bundle: nil)
            self.present(vc, animated: true, completion: nil)
        }
        toolsView.didSpeedTapped = {
            self.showSpeed()
        }
        toolsView.didRepeatTapped = {
            self.showRepeat()
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private
    
    func refresh() {
        toolsView.isHidden = true
        self.containerView.isHidden = true
        self.toolsView.hideAll()
        self.playerView.dismiss()
    }
    
    func dismissAlert() {
        let alert = UIAlertController(title: nil, message: "Вы действительно хотите выйти? Все изменения будут потеряны", preferredStyle: .actionSheet)
        let ok = UIAlertAction.init(title: "Да", style: .default) { action in
            self.refresh()
        }
        let cancel = UIAlertAction.init(title: "Отмена", style: .default, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleVideo(_ url: URL) {
        self.videoURL = url
        self.playerView.setVideo(url: url)
        self.containerView.isHidden = false
        self.toolsView.setup(url: url, player: self.playerView.avPlayer!)
        self.toolsView.isHidden = false
    }
    
//    func dismissPlayerView() {
//        self.containerView.isHidden = true
//        self.playerView.dismiss()
//    }
//
    // MARK: - Actions
    
    @IBAction func onDidPickTapped(_ sender: Any) {
        self.imagePicker?.present(from: self.view)
    }
    
    func showRepeat() {
        let vc = RepeatViewController(nibName: nil, bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }

    func showSpeed() {
        let vc = SpeedViewController.init(rate: self.playerView.avPlayer?.rate ?? 1)
        vc.didChangeRate = { rate in
            self.playerView.avPlayer?.rate = rate
            self.playerView.avPlayer?.play()
        }
        self.present(vc, animated: true, completion: nil)
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

//extension MainController: CropViewControllerDelegate {
//    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        self.videoURL = nil
//        self.image = self.compressImage(image: image)
//        cropViewController.dismiss(animated: true, completion: nil)
//    }
//}

extension MainController: ImagePickerDelegate {
    
    func didSelectVideo(url: URL) {
        self.handleVideo(url)
    }
    
    func didSelect(image: UIImage?) {
//        assert(false, "Not supported")
    }
    
}
