//
//  HeaderView.swift
//  globoplay-quiz
//
//  Created by eduardo.silva on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 26)
        l.textColor = .white
        return l
    }()
    private let titleLabelSkeleton: UIView = {
        let l = UILabel()
        l.backgroundColor = Color.white
        return l
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = .white
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        return l
    }()
    private let descriptionLabelSkeleton: UIView = {
        let l = UILabel()
        l.backgroundColor = Color.white
        return l
    }()
    private let descriptionLabel2Skeleton: UIView = {
        let l = UILabel()
        l.backgroundColor = Color.white
        return l
    }()
    
    private let quizImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "header-wave"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = Color.darkGray
        return imageView
    }()
    private let quizImageViewSkeleton: UIView = {
        let l = UILabel()
        l.backgroundColor = Color.white
        return l
    }()
    
    private let bottomSpacingView: UIView = {
        let v = UIView()
        v.backgroundColor = Color.darkGray
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupAnchor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = Color.black
        
        // Header subviews
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(quizImageView)
        addSubview(bottomSpacingView)
        
        // Skeleton subviews
        addSubview(descriptionLabelSkeleton)
        addSubview(descriptionLabel2Skeleton)
        addSubview(titleLabelSkeleton)
    }
    
    private func setupAnchor() {
        // MARK: Header anchors
        titleLabel.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          bottom: descriptionLabel.topAnchor,
                          trailing: trailingAnchor,
                          insets: .init(top: 32, left: 32, bottom: 18, right: 32))
        
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        let quizImageViewHeightMultiplier: CGFloat = 0.2363636364
        quizImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: quizImageViewHeightMultiplier).isActive = true
        quizImageView.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 18).isActive = true
        quizImageView.bottomAnchor.constraint(equalTo: self.bottomSpacingView.topAnchor).isActive = true
        quizImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        quizImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // MARK: BottomSpacingView anchor
        bottomSpacingView.anchor(height: 16)
        bottomSpacingView.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        // MARK: Skeleton anchors
        titleLabelSkeleton.anchor(height: 11, width: 141)
        titleLabelSkeleton.anchorCenterXToSuperview()
        titleLabelSkeleton.anchor(top: topAnchor, insets: .init(top: 46, left: 0, bottom: 0, right: 0))
        
//        descriptionLabelSkeleton.anchor(top: <#T##NSLayoutYAxisAnchor?#>, leading: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, trailing: <#T##NSLayoutXAxisAnchor?#>, insets: .init(top: 35, left: 16, bottom: 0, right: 16))
    }
    
    func setup(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
