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
        case unselected(text: String)
        case correct(text: String)
        case correctNotSelected(text: String)
        case wrong(text: String)
        case wrongNotSelected(text: String)
        case timerEndedAndNoneSelected(text: String)
        case loading
        case error
        case finished(progress: Float)
    }
    
    // MARK: - Cell views
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
    
    // MARK: - Error views
    private let imageError: UIImageView = {
        let i = UIImageView(image: UIImage(named: "warning"))
        i.backgroundColor = Color.darkGray
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    // MARK: - Loading views
    private let labelSkeleton: UIView = {
        let v = UIView()
        v.backgroundColor = Color.darkGray
        v.layer.cornerRadius = 2
        return v
    }()
    
    // MARK: - Finished views
    private let finishedLabel: UILabel = {
        let l = UILabel()
        l.text = "0%"
        l.textColor = Color.white
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 30)
        return l
    }()
    
    private let finishedProgressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: UIProgressView.Style.default)
        pv.progressTintColor = Color.red
        pv.trackTintColor = Color.lightGray
        pv.progress = 0
        pv.layer.cornerRadius = 4
        return pv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(label)
        containerView.addSubview(labelSkeleton)
        containerView.addSubview(imageError)
        containerView.addSubview(finishedLabel)
        containerView.addSubview(finishedProgressView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.alpha = isHighlighted ? 0.5 : 1
        }
    }
    
    func setup(state: ChoiceCell.State) {
        let color: UIColor
        let borderWidth: CGFloat
        let borderColor: UIColor?
        switch state {
        case .unselected(let text):
            label.text = text
            label.textColor = Color.black
            color = Color.white
            borderWidth = 0
            borderColor = nil
            setImageError(hidden: true)
            setLabel(hidden: false)
            setSkeleton(hidden: true)
            setFinished(hidden: true)
        case .correct(let text):
            label.text = text
            label.textColor = Color.white
            color = Color.green
            borderWidth = 0
            borderColor = nil
            setImageError(hidden: true)
            setLabel(hidden: false)
            setSkeleton(hidden: true)
            setFinished(hidden: true)
        case .correctNotSelected(let text):
            label.text = text
            label.textColor = Color.green
            color = .clear
            borderWidth = 2
            borderColor = Color.green
            setImageError(hidden: true)
            setLabel(hidden: false)
            setSkeleton(hidden: true)
            setFinished(hidden: true)
        case .wrong(let text):
            label.text = text
            label.textColor = Color.white
            color = Color.red
            borderWidth = 0
            borderColor = nil
            setImageError(hidden: true)
            setLabel(hidden: false)
            setSkeleton(hidden: true)
            setFinished(hidden: true)
        case .wrongNotSelected(let text):
            label.text = text
            label.textColor = Color.lightGray
            color = .clear
            borderWidth = 2
            borderColor = Color.lightGray
            setImageError(hidden: true)
            setLabel(hidden: false)
            setSkeleton(hidden: true)
            setFinished(hidden: true)
        case .timerEndedAndNoneSelected(let text):
            label.text = text
            label.textColor = Color.lightGray
            color = .clear
            borderWidth = 2
            borderColor = Color.lightGray
            setLabel(hidden: false)
            setSkeleton(hidden: true)
            setFinished(hidden: true)
        case .loading:
            color = Color.white
            borderWidth = 0
            borderColor = nil
            setImageError(hidden: true)
            setLabel(hidden: true)
            setSkeleton(hidden: false)
            setFinished(hidden: true)
        case .error:
            borderColor = nil
            borderWidth = 0
            color = Color.darkGray
            setImageError(hidden: false)
            setLabel(hidden: true)
            setSkeleton(hidden: true)
            setFinished(hidden: true)
        case .finished(let progress):
            borderColor = nil
            borderWidth = 0
            color = Color.darkGray
            setImageError(hidden: true)
            setLabel(hidden: true)
            setSkeleton(hidden: true)
            setFinished(hidden: false)
            
            finishedLabel.text = "\(Int(progress*100))%"
            finishedProgressView.progress = progress
        }
        containerView.backgroundColor = color
        containerView.layer.borderWidth = borderWidth
        containerView.layer.borderColor = borderColor?.cgColor
    }
    
    private func setLabel(hidden: Bool) {
        label.isHidden = hidden
    }
    
    private func setSkeleton(hidden: Bool) {
        labelSkeleton.isHidden = hidden
    }
    
    private func setImageError(hidden: Bool) {
        imageError.isHidden = hidden
    }
    
    private func setFinished(hidden: Bool) {
        finishedLabel.isHidden = hidden
        finishedProgressView.isHidden = hidden
    }
    
    private func setupConstraints() {
        containerView.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             trailing: contentView.trailingAnchor,
                             insets: .init(top: 0, left: 14, bottom: 0, right: 14))
        label.fillSuperview()
        
        imageError.anchor(height: 141, width: 141)
        imageError.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
        imageError.anchorCenterXToSuperview()
        
        labelSkeleton.anchor(height: 8, width: 145)
        labelSkeleton.anchorCenterSuperview()
        
        finishedLabel.anchorCenterYToSuperview(constant: -20)
        finishedLabel.anchorCenterXToSuperview()
        
        finishedProgressView.anchorCenterYToSuperview(constant: 10)
        finishedProgressView.anchorCenterXToSuperview()
        finishedProgressView.anchor(height: 8, width: 180)
    }
}
