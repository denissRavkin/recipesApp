//
//  SavedRecipeTableViewCell.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 20.04.2021.
//

import UIKit

class SavedRecipeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awake from nib")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var tableView: UITableView!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var summaryButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        print("init")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("init")
    }
    
    required init?(coder: NSCoder) {
        super.init
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var viewModel: SavedRecipeTableViewCellModel! {
        didSet {
//            setupUI()
//            setStartConstraints()
            
           
        
            
            
            summaryButton.titleLabel?.numberOfLines = 2
            
            if let imageData = viewModel.imageData {
                recipeImageView.image = UIImage(data: imageData)
            } else {
                recipeImageView.image = #imageLiteral(resourceName: "???")
            }
            recipeNameLabel.text = viewModel.title
            summaryButton.setTitle(viewModel.summary, for: .normal)
        }
    }
    
    
    @IBAction func summaryButtonTouched() {
        summaryButton.titleLabel?.numberOfLines = 0
//        summaryButton.sizeToFit()
        viewModel.isCellDeployed.toggle()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
