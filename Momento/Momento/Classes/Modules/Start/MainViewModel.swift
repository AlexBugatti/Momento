//
//  MainViewModel.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import Foundation

protocol MainViewModelInterface {
    var didShowLoader: (() -> Void)? { get set }
    var didHideLoader: (() -> Void)? { get set }
    
    func save(url: URL)
}

class MainViewModel: MainViewModelInterface {

    var didShowLoader: (() -> Void)?
    var didHideLoader: (() -> Void)?
    
    func save(url: URL) {
        self.didShowLoader?()
        FileService.save(url: url) { errorString in
            self.didHideLoader?()
        }
        
    }
    
}
