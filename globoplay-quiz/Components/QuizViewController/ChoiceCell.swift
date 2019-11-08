//
//  ChoiceCell.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit


final class ChoiceCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    enum State {
        case unselected
        case correct
        case correctNotSelected
        case wrong
        case wrongNotSelected
    }
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = Color.white
        v.layer.cornerRadius = 4
        return v
    }()
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(label)
        
        containerView.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             trailing: contentView.trailingAnchor,
                             insets: .init(top: 0, left: 14, bottom: 0, right: 14))
        label.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.alpha = isHighlighted ? 0.5 : 1
        }
    }
    
    func setup(text: String, state: ChoiceCell.State) {
        label.text = text
        
        let textColor: UIColor
        let color: UIColor
        let borderWidth: CGFloat
        let borderColor: UIColor?
        switch state {
        case .unselected:
            textColor = Color.black
            color = Color.white
            borderWidth = 0
            borderColor = nil
        case .correct:
            textColor = Color.white
            color = Color.green
            borderWidth = 0
            borderColor = nil
        case .correctNotSelected:
            textColor = Color.green
            color = .clear
            borderWidth = 2
            borderColor = Color.green
        case .wrong:
            textColor = Color.white
            color = Color.red
            borderWidth = 0
            borderColor = nil
        case .wrongNotSelected:
            textColor = Color.lightGray
            color = .clear
            borderWidth = 2
            borderColor = Color.lightGray
        }
        label.textColor = textColor
        containerView.backgroundColor = color
        containerView.layer.borderWidth = borderWidth
        containerView.layer.borderColor = borderColor?.cgColor
    }
}
