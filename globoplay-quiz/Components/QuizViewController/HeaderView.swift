//
//  HeaderView.swift
//  globoplay-quiz
//
//  Created by eduardo.silva on 07/11/19.
//  Copyright © 2019 Globo. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func headerViewDidEndTimer()
}

final class HeaderView: UICollectionReusableView {
    
    enum State {
        case loaded(title: String, description: String, isTimerEnabled: Bool)
        case loading
        case error(title: String, description: String)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Properties
    weak var delegate: HeaderViewDelegate?
    private var timer = Timer()
    private var secondsLeft: Int = 5
    private let totalSeconds: Int = 5
    
    // MARK: - Header Views
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 26)
        l.textColor = .white
        return l
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 16)
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
    
    private let timerContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = Color.darkGray
        v.layer.cornerRadius = 30
        v.layer.shadowColor = Color.black.cgColor
        v.layer.shadowOpacity = 0.7
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 10
        return v
    }()
    
    private let timerLabel: UILabel = {
        let l = UILabel()
        l.text = "0"
        l.textColor = Color.white
        l.font = UIFont.boldSystemFont(ofSize: 20)
        return l
    }()
    
    // MARK: - Skeleton views
    
    private let titleLabelSkeleton: UIView = {
        let v = UIView()
        v.backgroundColor = Color.white
        v.layer.cornerRadius = 2
        return v
    }()
    private let descriptionLabelSkeleton: UIView = {
        let v = UIView()
        v.backgroundColor = Color.white
        v.layer.cornerRadius = 2
        return v
    }()
    private let descriptionLabel2Skeleton: UIView = {
        let v = UIView()
        v.backgroundColor = Color.white
        v.layer.cornerRadius = 2
        return v
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupAnchor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer.invalidate()
    }
    
    // MARK: - Public functions
    
    func setup(state: State) {
        switch state {
        case .loaded(let title, let description, let isTimerEnabled):
            titleLabel.text = title
            descriptionLabel.text = description
            setLabels(hidden: false)
            setSkeletons(hidden: true)
            shimmerSkeletons(false)
            setTimer(hidden: !isTimerEnabled)
            timer.invalidate()
            if isTimerEnabled {
                setupTimer()
            }
        case .loading:
            titleLabel.text = ""
            descriptionLabel.text = ""
            setLabels(hidden: true)
            setSkeletons(hidden: false)
            shimmerSkeletons(false)
            setTimer(hidden: true)
        case .error(let title, let description):
            titleLabel.text = title
            descriptionLabel.text = description
            setLabels(hidden: false)
            setSkeletons(hidden: true)
            shimmerSkeletons(false)
            setTimer(hidden: true)
        }
    }
    
    // MARK: - Private functions
    
    private func setupViews() {
        backgroundColor = Color.black
        
        // Header subviews
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(quizImageView)
        addSubview(bottomSpacingView)
        
        // Skeleton subviews
        addSubview(titleLabelSkeleton)
        addSubview(descriptionLabelSkeleton)
        addSubview(descriptionLabel2Skeleton)
        
        // Timer subviews
        addSubview(timerContainerView)
        timerContainerView.addSubview(timerLabel)
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
        
        bottomSpacingView.anchor(height: 16)
        bottomSpacingView.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        // MARK: Skeleton anchors
        titleLabelSkeleton.anchor(height: 11, width: 141)
        titleLabelSkeleton.anchorCenterXToSuperview()
        titleLabelSkeleton.anchor(top: topAnchor, insets: .init(top: 46, left: 0, bottom: 0, right: 0))
        
        descriptionLabelSkeleton.anchor(height: 8)
        descriptionLabelSkeleton.anchor(top: titleLabelSkeleton.bottomAnchor,
                                        leading: leadingAnchor,
                                        trailing: trailingAnchor,
                                        insets: .init(top: 35, left: 16, bottom: 0, right: 16))
        
        descriptionLabel2Skeleton.anchor(height: 8)
        descriptionLabel2Skeleton.anchor(top: descriptionLabelSkeleton.bottomAnchor,
                                         leading: descriptionLabelSkeleton.leadingAnchor,
                                         trailing: descriptionLabelSkeleton.trailingAnchor,
                                         insets: .init(top: 12, left: 37, bottom: 0, right: 37))
        
        // MARK: Timer anchors
        timerContainerView.anchor(height: 60, width: 60)
        timerContainerView.anchor(bottom: bottomAnchor,
                                  trailing: trailingAnchor,
                                  insets: .init(top: 0, left: 0, bottom: 20, right: 15))
        
        timerLabel.anchorCenterSuperview()
    }
    
    func setupTimer() {
        timer.invalidate()
        secondsLeft = totalSeconds
        timerLabel.text = "\(secondsLeft)"
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if self.secondsLeft == 1 {
                self.delegate?.headerViewDidEndTimer()
                timer.invalidate()
                return
            }
            self.secondsLeft -= 1
            self.timerLabel.text = "\(self.secondsLeft)"
        })
    }
    
    private func setLabels(hidden: Bool) {
        titleLabel.isHidden = hidden
        descriptionLabel.isHidden = hidden
    }
    
    private func setTimer(hidden: Bool) {
        timerContainerView.isHidden = hidden
    }
    
    private func setSkeletons(hidden: Bool) {
        titleLabelSkeleton.isHidden = hidden
        descriptionLabelSkeleton.isHidden = hidden
        descriptionLabel2Skeleton.isHidden = hidden
    }
    
    private func shimmerSkeletons(_ isShimmering: Bool) {
        if isShimmering {
            titleLabelSkeleton.startShimmering()
            descriptionLabelSkeleton.startShimmering()
            descriptionLabel2Skeleton.startShimmering()
        } else {
            titleLabelSkeleton.stopShimmering()
            descriptionLabelSkeleton.stopShimmering()
            descriptionLabel2Skeleton.stopShimmering()
        }
    }
}
