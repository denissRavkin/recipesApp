//
//  RecipeEnvelopeCollectionViewCell.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 07.02.2021.
//

import UIKit

class RecipeEnvelopeCollectionViewCell: UICollectionViewCell {
    var recipeNameLabel: UILabel = UILabel()
    var recipeImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init frame")
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: RecipeEnvelopeCollectionViewCellViewModelProtocol! {
        didSet {
            recipeNameLabel.text = viewModel.title
            
            recipeImageView.image = nil
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                let imageStringUrl = viewModel.imageStringUrl
                guard let imageUrl = URL(string: viewModel.imageStringUrl) else {
                    print("url failed")
                    DispatchQueue.main.async {
                        recipeImageView.image = #imageLiteral(resourceName: "???")
                    }
                    return
                }
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        if imageStringUrl == viewModel.imageStringUrl {
                            recipeImageView.image = UIImage(data: imageData)
                        } else {
                            print("œelse dispatch")
                        }
                    }
                }
                
            }
        }
    }
    
    func setupUI() {
        setupRecipeNameLabel()
        setupImageView()
        setupCell()
    }
    
    func setupImageView() {
        recipeImageView.layer.cornerRadius = CGFloat(20)
        recipeImageView.layer.masksToBounds = true
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recipeImageView)
    }
    
    func setupRecipeNameLabel() {
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.numberOfLines = 2
        recipeNameLabel.textAlignment = NSTextAlignment(.center)
        recipeNameLabel.adjustsFontSizeToFitWidth = true
        recipeNameLabel.minimumScaleFactor = 0.5
        self.addSubview(recipeNameLabel)
    }
    
    func setupCell() {
        self.backgroundColor = .white
        self.layer.cornerRadius = CGFloat(20)
        self.layer.shadowRadius = CGFloat(5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -2, height: 4)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            recipeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            recipeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            recipeImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            
            recipeNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            recipeNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            recipeNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            recipeNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
        ])
    }
}
