//
//  StickersController.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import UIKit

class Sticker {
    var id: Int
    var image: UIImage?
    
    init(id: Int) {
        self.id = id
        self.image = UIImage(named: "\(id).png")
    }
    
}

class StickersController: BottomPopupViewController {

    override var popupHeight: CGFloat {
        let height = UIScreen.main.bounds.height
        return height - 100
    }
    
    var stickers: [Sticker] = []
    let range = 129..<168
//    let IDs: [Int] = [130,131,132,133,134,135,16,137,138,139,140,141,142,143,144,145,146,147]
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.register(UINib.init(nibName: "StickerCell", bundle: nil), forCellWithReuseIdentifier: "StickerCell")
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 24)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.frame.height)
        self.stickers = range.map({ Sticker(id: $0) })
        self.collectionView.reloadData()
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

extension StickersController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerCell
        let sticker = stickers[indexPath.row]
        cell.imageView.image = sticker.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 120) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
}
