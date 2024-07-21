//
//  CollectionCell.swift
//  WeatherAnimations
//
//  Created by Uliana Lukash on 21.07.2024.
//

import Foundation
import UIKit

final class CollectionCell: UICollectionViewCell, ReuseIdentifying {
    // MARK: Public Properties
    
    // MARK: Private Properties
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    // MARK: Private Methods
    private func configCellLayout() {
        contentView.backgroundColor = .red
    }
}
