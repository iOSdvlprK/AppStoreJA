//
//  TodayCell.swift
//  AppStoreJA
//
//  Created by joe on 2023/05/13.
//

import UIKit

class TodayCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            imageView.image = todayItem.image
            descriptionLabel.text = todayItem.description
            
            backgroundColor = todayItem.backgroundColor
            backgroundView?.backgroundColor = todayItem.backgroundColor
        }
    }
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing Your Time", font: .boldSystemFont(ofSize: 28))
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "garden"))
    
    let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 16), numberOfLines: 3)
    
    var topConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
//        clipsToBounds = true
        layer.cornerRadius = 16
        
        [categoryLabel, titleLabel, descriptionLabel].forEach {
            $0.textColor = UIColor.black
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: CGSize(width: 240, height: 240))
        
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel, titleLabel, imageContainerView, descriptionLabel
        ], spacing: 8)
        addSubview(stackView)
//        stackView.fillSuperview(padding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24))
        self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
