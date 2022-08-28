//
//  UIImageView+URL.swift
//  wantedAPI
//
//  Created by OsakaMiseri on 2022/08/28.
//

import UIKit
import Nuke

extension UIImageView {
    func loadImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        loadImage(with: url)
    }

    func loadImage(with url: URL) {
        Nuke.loadImage(with: url, into: self)
    }
}
