//
//  ViewController.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 01.02.2021.
//

import UIKit

class MainListOfRecipesViewController: UIViewController, UIGestureRecognizerDelegate {
    let filterCellId = "filterCellId"
    
    var searchTextField: UITextField!
    var searchButton: UIButton = UIButton()
    var cuisineFilterButton: UIButton!
    var mealTypeFilterButton: UIButton!
    var filterButtonsStackView: UIStackView!
    var recipesCollectionView: RecipesCollectionView!
    var noResultLabel: UILabel!
    
    var collectionViewFilters: UICollectionView!
    var visualEffectFiltersView: UIVisualEffectView!
    
    var viewModel: MainListOfRecipesViewModelProtocol!
    
    var collectionViewTopAnchorConstraint: NSLayoutConstraint!
    var visualEffectFiltersViewTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainListOfRecipesViewModel()
        setupUI()
        fetchRecipeTittleImage()
        setupUIConstraints()
    }
    
    func fetchRecipeTittleImage() {
        recipesCollectionView.activityIndicator.startAnimating()
        viewModel.recipes.value = []
        var soughtForRecipeName: String = ""
        if let searchTextField = searchTextField, let searchText = searchTextField.text  {
            soughtForRecipeName = searchText
        }
        viewModel.fetchRecipeTittleImage(soughtRecipeName: soughtForRecipeName) {
            DispatchQueue.main.async {
                if self.viewModel.recipes.value.count == 0 {
                    self.showNoResultLabel()
                }
                self.recipesCollectionView.activityIndicator.stopAnimating()
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0.6163546954, blue: 0.01877258797, alpha: 1)
        setupNavigationBar()
        setupTabBar()
        setupSearchTextField()
        setupSearchButton()
        setupFilterButtons()
        setupCollectionView()
        setupNoResultLabel()
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = viewModel.titleForNavigationBar.value
        viewModel.titleForNavigationBar.bindListener { [weak self] (titleForNavigation) in
            self?.navigationItem.title = titleForNavigation
        }
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.6163546954, blue: 0.01877258797, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.font : UIFont(name: UIFont.familyNames[1], size: 20)! , .foregroundColor: UIColor.white]
    }
    
    func setupTabBar() {
        tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    }
    
    func setupSearchTextField() {
        searchTextField = UITextField()
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "Find recipes"
        searchTextField.clearButtonMode = .always
        searchTextField.delegate = self
        view.addSubview(searchTextField)
    }
    
    func setupSearchButton() {
        searchButton.setImage(UIImage(systemName: "arrow.2.circlepath"), for: .normal)
        searchButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchButton.layer.shadowOpacity = 0.7
        searchButton.layer.shadowOffset = CGSize(width: -2 , height: 4)
        searchButton.layer.shadowRadius = 3
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        view.addSubview(searchButton)
    }
    
    func setupFilterButtons() {
        setupCuisineFilterButton()
        setupMealTypeFilterButton()
        setupFilterButtonsStackView()
    }
    
    func setupCuisineFilterButton() {
        cuisineFilterButton = setupFilterButton(title: "Cuisine")
        cuisineFilterButton.tag = 0
        cuisineFilterButton.addTarget(self, action: #selector(filterButtonTapped(button:)), for: .touchUpInside)
    }
    
    func setupMealTypeFilterButton() {
        mealTypeFilterButton = setupFilterButton(title: "Meal Type")
        mealTypeFilterButton.tag = 1
        mealTypeFilterButton.addTarget(self, action: #selector(filterButtonTapped(button:)), for: .touchUpInside)
    }
    func setupFilterButtonsStackView() {
        filterButtonsStackView = UIStackView(arrangedSubviews: [
            cuisineFilterButton, mealTypeFilterButton
        ])
        filterButtonsStackView.distribution = .fillEqually
        filterButtonsStackView.spacing = 10
        view.addSubview(filterButtonsStackView)
    }
    
    func setupFilterButton(title: String) -> UIButton {
        let filterButton = UIButton()
        filterButton.setTitle(title, for: .normal)
        filterButton.setTitleColor(#colorLiteral(red: 0, green: 0.5, blue: 0.01522872147, alpha: 1), for: .normal)
        filterButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        filterButton.layer.cornerRadius = 15
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return filterButton
    }
    
    @objc func filterButtonTapped(button: UIButton) {
        
        searchTextField.resignFirstResponder()
        
        switch button.tag {
        case 0:
            viewModel.selectedFilterType = Cuisine.self
            print("cuisineB")
        case 1:
            viewModel.selectedFilterType = MealType.self
            print("mealTB")
        default:
            print("Default")
        }
        
        if collectionViewFilters == nil {
            setupFilterCollectionView()
        }
        collectionViewFilters.reloadData()
        if visualEffectFiltersView == nil {
            createVisualEffectFiltersView()
        }
        visualEffectFiltersView.contentView.addSubview(collectionViewFilters)
        UIView.animate(withDuration: 0.3) {
            self.visualEffectFiltersViewTrailingConstraint.isActive = false
            self.visualEffectFiltersViewTrailingConstraint = self.visualEffectFiltersView.trailingAnchor.constraint(equalTo: self.recipesCollectionView.trailingAnchor)
            self.visualEffectFiltersViewTrailingConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    func createVisualEffectFiltersView() {
        visualEffectFiltersView = UIVisualEffectView(frame: CGRect(x: recipesCollectionView.frame.minX, y: recipesCollectionView.frame.minY, width: 0, height: recipesCollectionView.frame.height))
        visualEffectFiltersView.effect = UIBlurEffect(style: .light)
        view.addSubview(visualEffectFiltersView!)
        
        visualEffectFiltersView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectFiltersView.contentView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectFiltersViewTrailingConstraint = visualEffectFiltersView.trailingAnchor.constraint(equalTo: recipesCollectionView.leadingAnchor)
        NSLayoutConstraint.activate([
            visualEffectFiltersView.topAnchor.constraint(equalTo: recipesCollectionView.topAnchor),
            visualEffectFiltersView.leadingAnchor.constraint(equalTo: recipesCollectionView.leadingAnchor),
            visualEffectFiltersViewTrailingConstraint,
            visualEffectFiltersView.bottomAnchor.constraint(equalTo: recipesCollectionView.bottomAnchor),
            
            visualEffectFiltersView.contentView.topAnchor.constraint(equalTo: visualEffectFiltersView.topAnchor),
            visualEffectFiltersView.contentView.leadingAnchor.constraint(equalTo: visualEffectFiltersView.leadingAnchor),
            visualEffectFiltersView.contentView.trailingAnchor.constraint(equalTo: visualEffectFiltersView.trailingAnchor),
            visualEffectFiltersView.contentView.heightAnchor.constraint(equalTo: visualEffectFiltersView.heightAnchor, multiplier: 0.5)
        ])
    }
   
    func setupFilterCollectionView() {
        collectionViewFilters = UICollectionView(frame: CGRect(x: 5, y: 5, width: recipesCollectionView.frame.width - 10, height: recipesCollectionView.frame.height / 2 ), collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewFilters.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        (collectionViewFilters.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewFilters.dataSource = self
        collectionViewFilters.delegate = self
        collectionViewFilters.layer.cornerRadius = 10
        collectionViewFilters.register(SearchFilterCollectionViewCell.self, forCellWithReuseIdentifier: filterCellId)
        collectionViewFilters.tag = 1
    }
    
    func setupCollectionView() {
        recipesCollectionView = RecipesCollectionView()
        recipesCollectionView.dataSource = self
        recipesCollectionView.delegate = self
        recipesCollectionView.swipeDelegate = self
        view.addSubview(recipesCollectionView)
        viewModel.recipes.bindListener { _ in
            DispatchQueue.main.async {
                self.recipesCollectionView.reloadData()
            }
        }
    }
    
    func setupUIConstraints() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        recipesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filterButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionViewTopAnchor = recipesCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10)
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            searchTextField.heightAnchor.constraint(equalToConstant: CGFloat(30)),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            
            searchButton.widthAnchor.constraint(equalToConstant: CGFloat(30)),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            searchButton.heightAnchor.constraint(equalToConstant: CGFloat(30)),
            
            filterButtonsStackView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            filterButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionViewTopAnchor,
            recipesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            recipesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            noResultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            noResultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            noResultLabel.centerYAnchor.constraint(equalTo: recipesCollectionView.centerYAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            recipesCollectionView.gradientLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if visualEffectFiltersView?.frame.height == recipesCollectionView.frame.height {
            removeVisualEffectFilterViewWithAnimation()
        }
        if searchTextField.isFirstResponder {
            searchTextField.resignFirstResponder()
        }
        print("touches began")
    }
    
    @objc func searchButtonPressed() {
        hideNoResultLabel()
        print("search button pressed")
        if visualEffectFiltersView?.frame.height == recipesCollectionView.frame.height {
            removeVisualEffectFilterViewWithAnimation()
        }
        searchTextField.resignFirstResponder()
        print(searchTextField.text!)
        fetchRecipeTittleImage()
    }
 
    func removeVisualEffectFilterViewWithAnimation() {
        UIView.animate(withDuration: 0.3) {
                self.visualEffectFiltersViewTrailingConstraint.isActive = false
                self.visualEffectFiltersViewTrailingConstraint = self.visualEffectFiltersView?.trailingAnchor.constraint(equalTo: self.recipesCollectionView.leadingAnchor)
                self.visualEffectFiltersViewTrailingConstraint.isActive = true
            self.view.layoutIfNeeded()
        } completion: { (isAnimationEnd) in
            if isAnimationEnd {
                if !self.visualEffectFiltersView.contentView.subviews.isEmpty {
                    self.visualEffectFiltersView.contentView.subviews[0].removeFromSuperview()
                }
            }
        }
    }
    
    func setupNoResultLabel() {
        noResultLabel = UILabel()
        noResultLabel.textColor = .white
        noResultLabel.numberOfLines = 0
        noResultLabel.isHidden = true
        recipesCollectionView.addSubview(noResultLabel)
    }
    
    func showNoResultLabel() {
        let cuisineFiltersString = viewModel.selectedCuisineFilters.map { $0.rawValue }.joined(separator:", ")
        let mealTypeString = viewModel.selectedMealTypeFilters.map { $0.rawValue }.joined(separator:", ")
    
        noResultLabel?.text = """
                              No result by search: \(viewModel.soughtRecipeName)
                              Cuisine: \(cuisineFiltersString)
                              Meal type: \(mealTypeString)
                              """
        noResultLabel.isHidden = false
    }
    
    func hideNoResultLabel() {
        noResultLabel.text = ""
        noResultLabel.isHidden = true
    }
    
    func showFilterButtonWithAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            collectionViewTopAnchor.isActive = false
            collectionViewTopAnchor = self.recipesCollectionView.topAnchor.constraint(equalTo: self.filterButtonsStackView.bottomAnchor, constant: 10)
            collectionViewTopAnchor.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    func hideFilterButtonWithAnimation() {
        UIView.animate(withDuration: 0.2) {
            collectionViewTopAnchor.isActive = false
            collectionViewTopAnchor = self.recipesCollectionView.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 10)
            collectionViewTopAnchor.isActive = true
            self.view.layoutIfNeeded()
        }
    }
}

extension MainListOfRecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return viewModel.recipes.value.count
        case 1:
            if viewModel.selectedFilterType is Cuisine.Type {
                return Cuisine.allCases.count
            } else if viewModel.selectedFilterType is MealType.Type {
                return MealType.allCases.count
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeEnvelopeCollectionViewCell
            cell.viewModel = viewModel.viewModelCollectionViewCell(index: indexPath.row)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellId, for: indexPath) as! SearchFilterCollectionViewCell
            cell.viewModel = viewModel.viewModelFilterCollectionViewCell(index: indexPath.row)
            return cell
        default:
            print("default")
        }
        
        return UICollectionViewCell()
    }
}
extension MainListOfRecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModelForDetailVC = viewModel.viewModelDetailViewController(byIndexPath: indexPath)
        let vc = DetailRecipeViewController(viewModel: viewModelForDetailVC)
        vc.viewModel = viewModelForDetailVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainListOfRecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return CGFloat(5)
    }

}
 
var collectionViewTopAnchor: NSLayoutConstraint!
extension MainListOfRecipesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("....")
        showFilterButtonWithAnimation()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        hideNoResultLabel()
        fetchRecipeTittleImage()
        hideFilterButtonWithAnimation()
        searchTextField.resignFirstResponder()
        return false
    }
}

extension MainListOfRecipesViewController: SwipeUpOnRecipesCollectionViewDelegate {
    func swipeUpOnRecipesCollectionView() {
        searchTextField.resignFirstResponder()
        hideFilterButtonWithAnimation()
        print("gesture up")
    }
}
