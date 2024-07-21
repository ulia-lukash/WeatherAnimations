//
//  CellReusingUtils.swift
//  WeatherAnimations
//
//  Created by Uliana Lukash on 21.07.2024.
//

import UIKit

protocol ReuseIdentifying {
    static var defaultReuseIdentifier: String { get }
}

extension ReuseIdentifying where Self: UICollectionViewCell {
    static var defaultReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReuseIdentifying {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier) for: \(indexPath)")
            return T()
        }
        return cell
    }
}
