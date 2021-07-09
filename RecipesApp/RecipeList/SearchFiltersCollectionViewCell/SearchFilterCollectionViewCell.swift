//
//  SearchFilterCollectionViewCell.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 01.03.2021.
//

import UIKit

class SearchFilterCollectionViewCell: UICollectionViewCell {
    let filterButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFilterButton()
        setupCell()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: SearchFilterCollectionViewCellViewModelProtocol! {
        didSet {
            viewModel.filterIsSelected.bindListener { [weak self] (filterIsSelected) in
                self?.filterButton.backgroundColor = filterIsSelected ? .green : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            filterButton.setTitle(" \(viewModel.filterName) ", for: .normal)
            filterButton.backgroundColor = viewModel.filterIsSelected.value ? .green : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    func setupCell() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.addSubview(filterButton)
    }
    
    func setupFilterButton() {
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.titleLabel?.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .callout), size: 17)
        filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
    }
    
    @objc func filterButtonPressed() {
        viewModel.filterIsSelected.value.toggle()
    }
    
    func setupConstraint() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            filterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            filterButton.topAnchor.constraint(equalTo: self.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
