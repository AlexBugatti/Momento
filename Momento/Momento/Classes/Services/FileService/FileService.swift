//
//  FileService.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import UIKit
import Photos

class FileService {

    class func save(url: URL, completion: @escaping ((String?) -> Void)) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { saved, error in
            if saved {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

                let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions).firstObject
                completion(nil)
                
                // fetchResult is your latest video PHAsset
                // To fetch latest image  replace .video with .image
            } else {
                completion(error?.localizedDescription)
            }
        }
    }
    
}
