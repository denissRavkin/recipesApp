//
//  SavedRecipesTableViewController.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 05.02.2021.
//

import UIKit

class SavedRecipesTableViewController: UITableViewController {
    var viewModel: SavedRecipesViewModelProtocol = SavedRecipesViewModel()
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        setupNavigationBar()
        setupTableView()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSavedRecipes {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.saveChanges()
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search saved recipes"
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.searchController = searchController
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = viewModel.titleForNavigationBar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.6163546954, blue: 0.01877258797, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.font : UIFont(name: UIFont.familyNames[1], size: 20)! , .foregroundColor: UIColor.white]
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "SavedRecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "savedRecipeID")
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableHeaderView")
        tableView.separatorColor = #colorLiteral(red: 0, green: 0.5, blue: 0.01522872147, alpha: 1)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 50
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeID", for: indexPath) as! SavedRecipeTableViewCell
        cell.viewModel = viewModel.viewModelForTableViewCell(by: indexPath)
        cell.tableView = tableView

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeaderView") as! TableHeaderView
        headerView.titleLabel.text = viewModel.titleLabelForHeaderView(inSection: section)
        headerView.imageView.image = UIImage(systemName: viewModel.systemNameOfImageForHeaderView(inSection: section))
        return headerView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt at" + "\(indexPath.row)")
        let viewModelForDetailVC = viewModel.viewModelDetailViewController(byIndexPath: indexPath)
        let detailRecipeViewController = DetailRecipeViewController(viewModel: viewModelForDetailVC)
        
        navigationController?.pushViewController(detailRecipeViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favouriteAction = UIContextualAction(style: .destructive, title: "") { [self] (action, view, handler) in
            viewModel.changeSectionForRecipe(atIndexPath: indexPath)
            let cell = tableView.cellForRow(at: indexPath) as! SavedRecipeTableViewCell
            cell.viewModel.indexPath = indexPath
            tableView.moveRow(at: indexPath, to: viewModel.newSectionForMovableCell(indexPath))
            handler(true)
        }
        favouriteAction.backgroundColor = #colorLiteral(red: 0, green: 0.6163546954, blue: 0.01877258797, alpha: 1)
        favouriteAction.image = UIImage(systemName: viewModel.systemNameImageForFavouriteSwipeAction(byIndex: indexPath))
        
        let configuration = UISwipeActionsConfiguration(actions: [favouriteAction])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [self] (_, _, handler) in
            viewModel.deleteRecipe(byIndex: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension SavedRecipesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.searchBar.text!.isEmpty && searchController.isActive {
            viewModel.isFiltering = true
        } else {
            viewModel.isFiltering = false
            tableView.reloadData()
        }
        if viewModel.isFiltering {
            viewModel.filterRecipesForSearchText(searchText: searchController.searchBar.text!)
            tableView.reloadData()
        }
    }
}

extension SavedRecipesTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search saved recipes", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0.5, blue: 0.0152, alpha: 1)])
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search saved recipes", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
}
