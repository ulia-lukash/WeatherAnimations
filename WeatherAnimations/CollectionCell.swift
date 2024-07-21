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
    
    lazy private var imageButton = UIButton()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    func configure(_ item: WeatherInst) {
        let imageName = item.imageName
        let image = UIImage(systemName: imageName)
        imageButton.setImage(image, for: .normal)
    }
    
    // MARK: Private Methods
    
    private func configCellLayout() {
        [imageButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
