//
//  UICollectionView+Register.swift.swift
//  wantedAPI
//
//  Created by OsakaMiseri on 2022/08/20.
//

import UIKit

public enum CollectionElementKindSection: CustomStringConvertible {
    case header
    case footer

    public var description: String {
        switch self {
        case .header:
            return UICollectionView.elementKindSectionHeader

        case .footer:
            return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionView {
    public func registerNib<T: UICollectionViewCell>(type: T.Type) {
        let nib = UINib(nibName: type.className, bundle: Bundle(for: type))
        register(nib, forCellWithReuseIdentifier: type.className)
    }

    public func registerNib<T: UICollectionReusableView>(type: T.Type, for kind: CollectionElementKindSection) {
        let nib = UINib(nibName: type.className, bundle: Bundle(for: type))
        register(nib, forSupplementaryViewOfKind: kind.description, withReuseIdentifier: type.className)
    }

    public func registerClass<T: UICollectionViewCell>(type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: type.className)
    }

    public func registerClass<T: UICollectionReusableView>(type: T.Type, for kind: CollectionElementKindSection) {
        register(T.self, forSupplementaryViewOfKind: kind.description, withReuseIdentifier: type.className)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }

    public func dequeueReusableCell<T: UICollectionReusableView>(kind: String, withReuseType type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as! T
    }

    public func dequeueReusableCell<T: UICollectionReusableView>(kind: CollectionElementKindSection, withReuseType type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: kind.description, withReuseIdentifier: type.className, for: indexPath) as! T
    }
}
