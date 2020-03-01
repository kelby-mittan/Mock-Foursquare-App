//
//  UsersCollectionsCell.swift
//  Mock-Foursquare-App
//
//  Created by Kelby Mittan on 2/24/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

protocol CollectionCellDelegate: AnyObject {
    func didLongPress(_ collectionsCell: UsersCollectionsCell, collection: UserCollection)
    func didPressX(_ collectionsCell: UsersCollectionsCell, collection: UserCollection)
}

class UsersCollectionsCell: UICollectionViewCell {
    
    public var userCollection: UserCollection!
    
    public lazy var collectionImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "photo.fill")
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    public lazy var xButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "xmark.circle.fill")
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .systemBackground
        iv.tintColor = .black
        iv.layer.cornerRadius = 40
        iv.isHidden = true
        return iv
    }()
    
    public lazy var alphaView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        return view
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "this is the title"
        label.textAlignment = .center
        label.textColor = .white
//        label.font = UIFont(name:"Helvetica Neue",size:22)
        label.font = UIFont(name:"AmericanTypewriter-Bold",size:22)
//        AmericanTypewriter-Bold
        return label
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()
    
    private lazy var didTap: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(buttonPressed(gesture:)))
        return gesture
    }()
    
    weak var cellDelegate: CollectionCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        addGestureRecognizer(longPressGesture)
        xButton.addGestureRecognizer(didTap)
        collectionImage.clipsToBounds = true
        alphaView.clipsToBounds = true
    }
    
    private func commonInit() {
        
        setupAlphaViewConstraints()
        
        setupVenueImageViewConstraints()
        setupTitleLabelConstraints()
        setupXButtonConstraints()
    }
    
    private func setupAlphaViewConstraints() {
        addSubview(alphaView)
        alphaView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alphaView.topAnchor.constraint(equalTo: contentView.topAnchor),
            alphaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            alphaView.trailingAnchor.constraint(equalTo: trailingAnchor),
            alphaView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupVenueImageViewConstraints() {
        addSubview(collectionImage)
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        
        collectionImage.alpha = 0.7
        NSLayoutConstraint.activate([
            collectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImage.widthAnchor.constraint(equalTo: widthAnchor),
            collectionImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setupTitleLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func setupXButtonConstraints() {
        addSubview(xButton)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            xButton.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            xButton.centerYAnchor.constraint(equalTo: self.topAnchor,constant: 6),
            xButton.widthAnchor.constraint(equalToConstant: 44),
            xButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func buttonPressed(gesture: UITapGestureRecognizer) {
        print("buttonPressed")
        if gesture.state == .began {
            gesture.state = .cancelled
            return
        }
        cellDelegate?.didPressX(self, collection: userCollection)
    }
    
    func configureCell(for collection: UserCollection) {
        guard let image = UIImage(data: collection.pickedImage) else {
            return
        }
        
        
        collectionImage.image = image
        titleLabel.text = collection.collectionName
    }
    
    @objc private func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            gesture.state = .cancelled
            return
        }
        cellDelegate?.didLongPress(self, collection: userCollection)
    }
}


extension UICollectionViewCell {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        layer.add(animation, forKey: "shake")
    }
}
