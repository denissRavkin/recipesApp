//
//  HeaderView.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 13.04.2021.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    var titleLabel = UILabel()
    var imageView = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupTitleLabel()
        setupImageView()
        setupContentView()
    }
    
    func setupContentView() {
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
    }
    
    func setupImageView() {
        contentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        imageViewBottomConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,multiplier: 3/4),
            imageViewBottomConstraint,

            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
