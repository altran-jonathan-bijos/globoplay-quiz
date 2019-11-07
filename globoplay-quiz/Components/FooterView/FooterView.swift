//
//  FooterView.swift
//  globoplay-quiz
//
//  Created by eduardo.silva on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

final class FooterView: UIView {
    
    private let footerImageView: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "footer-wave"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.darkGray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(footerImageView)
        self.setupAnchor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupAnchor() {
        // MARK: - FooterImageView Anchor
        self.footerImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.footerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.footerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.footerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
