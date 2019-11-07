//
//  ChoiceCell.swift
//  globoplay-quiz
//
//  Created by Jonathan Pereira Bijos on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit


final class ChoiceCell: UICollectionViewCell {
    
    enum State {
        case unselected
        case correct
        case correctNotSelected
        case wrong
        case wrongNotSelected
    }
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(text: String, state: ChoiceCell.State) {
        label.text = text
        
        let color: UIColor
        let textColor: UIColor
        let borderWidth: CGFloat
        let borderColor: UIColor?
        switch state {
        case .unselected:
            color = .white
            textColor = .black
            borderWidth = 0
            borderColor = nil
        case .correct:
            color = .green
            textColor = .white
            borderWidth = 0
            borderColor = nil
        case .correctNotSelected:
            color = .clear
            textColor = .green
            borderWidth = 2
            borderColor = .green
        case .wrong:
            color = .red
            textColor = .white
            borderWidth = 0
            borderColor = nil
        case .wrongNotSelected:
            color = .clear
            textColor = .lightGray
            borderWidth = 2
            borderColor = .lightGray
        }
        contentView.backgroundColor = color
        contentView.layer.borderWidth = borderWidth
        contentView.layer.borderColor = borderColor?.cgColor
    }
}
