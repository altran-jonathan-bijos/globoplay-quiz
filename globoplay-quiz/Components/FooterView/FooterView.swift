//
//  FooterView.swift
//  globoplay-quiz
//
//  Created by eduardo.silva on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

protocol FooterViewDelegate: AnyObject {
    func footerViewDidTapButton()
}

final class FooterView: UIView {
    
    enum State {
        case tryAgain
        case next
        case hidden
        case restart
    }
    
    weak var delegate: FooterViewDelegate?
    
    private let footerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "footer-wave"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = Color.darkGray
        return imageView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = .init(top: 0, left: 38, bottom: 0, right: 38)
        button.setTitleColor(Color.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        button.layer.cornerRadius = 25
        button.backgroundColor = Color.black
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(footerImageView)
        self.addSubview(nextButton)
        self.setupButton(state: .hidden)
        self.setupAnchor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupButton(state: FooterView.State) {
        switch state {
        case .next:
            nextButton.setTitle("Próximo", for: .normal)
            nextButton.isHidden = false
        case .hidden:
            nextButton.isHidden = true
        case .tryAgain:
            nextButton.setTitle("Tentar Novamente", for: .normal)
            nextButton.isHidden = false
        case .restart:
            nextButton.setTitle("Recomeçar", for: .normal)
            nextButton.isHidden = false
        }
    }
    
    private func setupAnchor() {
        // MARK: - FooterImageView Anchor
        self.footerImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.footerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.footerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.footerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        //MARK: - NextButton Anchor
        self.nextButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 51).isActive = true
    }
    
    @objc private func didTapButton() {
        delegate?.footerViewDidTapButton()
    }
}
