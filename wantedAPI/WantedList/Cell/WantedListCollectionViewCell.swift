//
//  WantedListCollectionViewCell.swift
//  wantedAPI
//
//  Created by OsakaMiseri on 2022/08/20.
//

import UIKit

final class WantedListCollectionViewCell: UICollectionViewCell {
    private enum Const {
        static let cornerRadius: CGFloat = 12
    }

    @IBOutlet private weak var boxView: UIView! {
        didSet {
            boxView.layer.cornerRadius = Const.cornerRadius
            boxView.layer.masksToBounds = true
            boxView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            boxView.layer.shadowColor = UIColor.darkGray.cgColor
            boxView.layer.shadowOpacity = 0.6
            boxView.layer.shadowRadius = 4
        }
    }
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func prepare(item: Item) {
        // titleLabel.text = item.title
        // rewardTextLabel.text = item.rewardText
    }

}
