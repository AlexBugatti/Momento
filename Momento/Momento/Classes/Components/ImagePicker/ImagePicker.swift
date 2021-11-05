//
//  ImagePicker.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
    func didSelectVideo(url: URL)
}

public enum MediaType: String {
    case video = "public.movie"
    case image = "public.image"
}


open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    private var types: [MediaType]
    
    var isSquare: Bool = false

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate, types: [MediaType], isSquare: Bool = false) {
        self.pickerController = UIImagePickerController()
        self.types = types
        self.isSquare = isSquare
        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.videoMaximumDuration = 30
        self.pickerController.mediaTypes = types.map({ $0.rawValue })
        self.pickerController.modalPresentationStyle = .fullScreen
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView, isSquare: Bool = false) {
        self.isSquare = isSquare
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Снять видео") {
            alertController.addAction(action)
        }
//        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
//            alertController.addAction(action)
//        }
        if let action = self.action(for: .photoLibrary, title: "Выбрать видео в галерее") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect url: URL) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelectVideo(url: url)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
//        guard let image = info[.editedImage] as? UIImage else {
//            return self.pickerController(picker, didSelect: nil)
//        }
        
        if isSquare == true {
            isSquare = false
            if let image = info[.editedImage] as? UIImage {
                return self.pickerController(picker, didSelect: image)
            }
        }
        
//        if let image = info[.cropRect] as? UIImage {
//            return self.pickerController(picker, didSelect: image)
//        }
        
        if let image = info[.originalImage] as? UIImage {
            return self.pickerController(picker, didSelect: image)
        }
        
        if let videoURL = info[.mediaURL] as? URL {
            return self.pickerController(picker, didSelect: videoURL)
        }
        
        self.pickerController(picker, didSelect: nil)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
