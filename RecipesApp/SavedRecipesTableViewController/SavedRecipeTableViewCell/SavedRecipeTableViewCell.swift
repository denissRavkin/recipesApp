//
//  SavedRecipeTableViewCell.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 20.04.2021.
//

import UIKit

class SavedRecipeTableViewCell: UITableViewCell {
    weak var tableView: UITableView!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var summaryButton: UIButton!
    
    var viewModel: SavedRecipeTableViewCellModel! {
        didSet {
            if viewModel.savedRecipe.isDeployed {
                summaryButton.titleLabel?.numberOfLines = 0
            } else {
                summaryButton.titleLabel?.numberOfLines = 2
            }
            
            if let imageData = viewModel.imageData {
                recipeImageView.image = UIImage(data: imageData)
            } else {
                recipeImageView.image = #imageLiteral(resourceName: "???")
            }
            recipeNameLabel.text = viewModel.title
            summaryButton.setTitle(viewModel.summary, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from nib")
        NSLayoutConstraint.activate([
            summaryButton.titleLabel!.topAnchor.constraint(equalTo: summaryButton.topAnchor),
            summaryButton.titleLabel!.bottomAnchor.constraint(equalTo: summaryButton.bottomAnchor),
            summaryButton.titleLabel!.trailingAnchor.constraint(equalTo: summaryButton.trailingAnchor),
            summaryButton.titleLabel!.leadingAnchor.constraint(equalTo: summaryButton.leadingAnchor)
        ])
    }

    @IBAction func summaryButtonTouched() {
        
        tableView.performBatchUpdates {
            if viewModel.savedRecipe.isDeployed {
                summaryButton.titleLabel?.numberOfLines = 2
            } else {
                summaryButton.titleLabel?.numberOfLines = 0
            }
        } completion: { (finished) in
            if finished {
                self.viewModel.savedRecipe.isDeployed.toggle()
            }
        }
    }
}
