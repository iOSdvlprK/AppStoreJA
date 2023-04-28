//
//  AppsGroupCell.swift
//  AppStoreJA
//
//  Created by joe on 2023/04/28.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
    }
}

class AppsGroupCell: UICollectionViewCell {
    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "App Section"
//        label.font = .boldSystemFont(ofSize: 30)
//        return label
//    }()
    
    let titleLabel = UILabel(text: "App Section", font: .boldSystemFont(ofSize: 30))
    
    let horizontalController = AppsHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        addSubview(horizontalController.view)
        horizontalController.view.backgroundColor = .systemBlue
        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
