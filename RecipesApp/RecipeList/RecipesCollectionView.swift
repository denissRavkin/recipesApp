//
//  RecipesCollectionView.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 28.04.2021.
//

import UIKit

protocol SwipeUpOnRecipesCollectionViewDelegate: class {
    func swipeUpOnRecipesCollectionView()
}

class RecipesCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    
    var activityIndicator: UIActivityIndicatorView!
    let cellId = "RecipeCell"
    weak var swipeDelegate: SwipeUpOnRecipesCollectionViewDelegate?
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupActivityIndicator()
        setupActivityIndicatorConstraints()
        setupGradientLayer()
        setupRecipesCollectionView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30)/2, height: (UIScreen.main.bounds.width - 30)/2)
        self.init(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addSubview(activityIndicator)
    }
    
    func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func setupRecipesCollectionView() {
        self.register(RecipeEnvelopeCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        let backgroundView = UIView(frame: self.frame)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundView = backgroundView
        self.tag = 0
    }
    
    func setupGesture() {
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpGestureOnCollectionView))
        swipeUpGestureRecognizer.direction = .up
        swipeUpGestureRecognizer.delegate = self
        self.addGestureRecognizer(swipeUpGestureRecognizer)
    }
    
    func setupGradientLayer() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [#colorLiteral(red: 0, green: 0.6163546954, blue: 0.01877258797, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.9426946848, blue: 0.1007128151, alpha: 1).cgColor]
    }
    
    @objc func swipeUpGestureOnCollectionView() {
        swipeDelegate?.swipeUpOnRecipesCollectionView()
    }
}
