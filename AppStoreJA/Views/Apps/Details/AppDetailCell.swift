//
//  AppDetailCell.swift
//  AppStoreJA
//
//  Created by joe on 2023/05/05.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
    
    let appIconImageView = UIImageView(cornerRadius: 16)
    
    let nameLabel = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
    
    let priceButton = UIButton(title: "$4.99")
    
    let whatsNewLabel = UILabel(text: "What's New", font: .boldSystemFont(ofSize: 20))
    
    let releaseNotesLabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        appIconImageView.backgroundColor = .systemRed
        appIconImageView.constrainWidth(constant: 140)
        appIconImageView.constrainHeight(constant: 140)
        
        priceButton.backgroundColor = #colorLiteral(red: 0.1727995276, green: 0.4291955829, blue: 0.9010459781, alpha: 1)
        priceButton.constrainHeight(constant: 32)
        priceButton.constrainWidth(constant: 80)
        priceButton.layer.cornerRadius = 32 / 2
        priceButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        priceButton.setTitleColor(.white, for: .normal)
        
        let stackView = VerticalStackView(
            arrangedSubviews: [
                UIStackView(arrangedSubviews: [
                    appIconImageView,
                    VerticalStackView(arrangedSubviews: [
                        nameLabel,
                        UIStackView(arrangedSubviews: [priceButton, UIView()]),
                        UIView()
                    ], spacing: 12)
                ], customSpacing: 20),
                whatsNewLabel,
                releaseNotesLabel
            ],
            spacing: 16
        )
        addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = customSpacing
    }
}
