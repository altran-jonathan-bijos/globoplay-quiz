//
//  HeaderView.swift
//  globoplay-quiz
//
//  Created by eduardo.silva on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    
    static let identifier: String = "Header"
    
    private let label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 20.0)
        l.textColor = .white
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        return l
    }()
    
    private let quizImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "header-wave"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = Color.darkGray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.black
        self.addSubview(label)
        self.addSubview(quizImageView)
        self.setupAnchor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAnchor() {
        // MARK: - Description Anchor
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        // MARK: - Image Anchor
        quizImageView.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        quizImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.277).isActive = true
        quizImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        quizImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        quizImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func setup(_ desc: String) {
        label.text = desc
    }
}
