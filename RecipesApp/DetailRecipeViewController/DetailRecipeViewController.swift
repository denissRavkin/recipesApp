//
//  DetailRecipeViewController.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 10.02.2021.
//

import UIKit

class DetailRecipeViewController: UIViewController, UIGestureRecognizerDelegate {
    var saveRecipeBarButtonItem: UIBarButtonItem!
    var activityIndicator: UIActivityIndicatorView!
    
    var scrollView: UIScrollView!
    
    var imageView: UIImageView!
    
    var vegetarianlabel: UILabel!
    var veganLabel: UILabel!
    var glutenFreeLabel: UILabel!
    var dairyFreeLabel: UILabel!
    var veryHealthyLabel: UILabel!
    var cheapLabel: UILabel!
    var veryPopularLabel: UILabel!
    var stackViewTags: UIStackView!
    
    var aggregateLikesImageView: UIImageView!
    var aggregateLikesLabel: UILabel!
    
    var spoonacularScoreImageView: UIImageView!
    var spoonacularScoreLabel: UILabel!
    
    var healthScoreImageView: UIImageView!
    var healthScoreLabel:  UILabel!
    
    var pricePerServingImageView: UIImageView!
    var pricePerServingLabel: UILabel!
    
    var readyInMinutesImageView: UIImageView!
    var readyInMinutesLabel: UILabel!
    
    var stackViewIconsLabels: UIStackView!
    
    var titleLabel: UILabel!
    var summaryLabel: UILabel!
    
    var cuisinesLabel: UILabel!
    var dishTypesLabel: UILabel!
    var dietsLabel: UILabel!
    
    var ingredients: [UILabel] = []
    var stackViewIngredientsLabels: UIStackView!
    
    var stepper: UIStepper!
    var servingsLabel: UILabel!
    var servingsStepperAndLabelStackView: UIStackView!

    var sourceUrlButton: UIButton!
    
    var viewModel: DetailRecipeViewModelProtocol!
    
    var imageViewTopAnchor: NSLayoutConstraint!
    var imageViewLeadingAnchor: NSLayoutConstraint!
    var imageViewTrailingAnchor: NSLayoutConstraint!
    var imageViewHeightAnchor: NSLayoutConstraint!
    var imageViewIsselected: Bool = false
    
    init(viewModel: DetailRecipeViewModelProtocol) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil)
       }
       
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupActivityIndicator()
        setupNavigationBar()
        viewModel.fetchRecipeData {
            DispatchQueue.main.async {
                self.setupUI()
                self.setupUIConstraint()
                self.activityIndicator.stopAnimating()
                self.saveRecipeBarButtonItem.isEnabled = true
            }
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        saveRecipeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveRecipe))
        saveRecipeBarButtonItem.isEnabled = false
        navigationItem.setRightBarButton(saveRecipeBarButtonItem, animated: false)
    }
    
    @objc func saveRecipe() {
        viewModel.saveRecipe()
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupUI() {
        setupScrollView()
        setupImageView()
        setupTagLabels()
        setupIconsWithLabels()
        setupTitleAndSummary()
        setupDietsCuisinesDishTypes()
        setupIngredientsLabels()
        setupServingsStepperAndLabel()
        setupButtonSourceOfRecipe()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.width, height: 2000)
        self.view.addSubview(scrollView)
    }
    
    func setupImageView() {
        if let imageData = viewModel.imageData {
            imageView = UIImageView(image: UIImage(data: imageData))
        } else {
            imageView = UIImageView(image: #imageLiteral(resourceName: "???"))
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnRecipeImage))
        imageView.isUserInteractionEnabled = true
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        scrollView.addSubview(imageView)
    }
    
    func setupTagLabels(){
        vegetarianlabel = tagLabel(name: " vegetarian ")
        vegetarianlabel.backgroundColor = viewModel.vegetarian ? .green : .red
        veganLabel = tagLabel(name: " vegan ")
        veganLabel.backgroundColor = viewModel.vegan ? .green : .red
        glutenFreeLabel = tagLabel(name: " gluten free ")
        glutenFreeLabel.backgroundColor = viewModel.glutenFree ? .green : .red
        dairyFreeLabel = tagLabel(name: " dairy free ")
        dairyFreeLabel.backgroundColor = viewModel.dairyFree ? .green : .red
        veryHealthyLabel = tagLabel(name: " very healthy ")
        veryHealthyLabel.backgroundColor = viewModel.veryHealthy ? .green : .red
        cheapLabel = tagLabel(name: " cheap ")
        cheapLabel.backgroundColor = viewModel.cheap ? .green : .red
        veryPopularLabel = tagLabel(name: " very popular ")
        veryPopularLabel.backgroundColor = viewModel.veryPopular ? .green : .red
        
        setupTagLabelsStackViews()
    }
    
    func tagLabel(name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = UIFont(name: UIFont.familyNames[5], size: 18)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        //label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }
    
    func setupTagLabelsStackViews() {
        let horizontalTagLabelsStackView1 = UIStackView(arrangedSubviews: [vegetarianlabel,veganLabel,cheapLabel])
        horizontalTagLabelsStackView1.spacing = 10
        horizontalTagLabelsStackView1.distribution = .fillProportionally
        
        let horizontalTagLabelsStackView2 = UIStackView(arrangedSubviews: [glutenFreeLabel,dairyFreeLabel])
        horizontalTagLabelsStackView2.spacing = 10
        horizontalTagLabelsStackView2.distribution = .fillProportionally
        
        let horizontalTagLabelsStackView3 = UIStackView(arrangedSubviews: [veryHealthyLabel,veryPopularLabel])
        horizontalTagLabelsStackView3.spacing = 10
        horizontalTagLabelsStackView3.distribution = .fillProportionally
        
        stackViewTags = UIStackView(arrangedSubviews:[
            horizontalTagLabelsStackView1, horizontalTagLabelsStackView2, horizontalTagLabelsStackView3
        ])
        stackViewTags.axis = .vertical
        stackViewTags.alignment = .center
        stackViewTags.spacing = 10
    
        scrollView.addSubview(stackViewTags)
    }
    
    func setupIconsWithLabels() {
        aggregateLikesImageView = UIImageView(image: #imageLiteral(resourceName: "popular-3"))
        aggregateLikesLabel = iconLabel(text: viewModel.aggregateLikes)
        
        healthScoreImageView = UIImageView(image: #imageLiteral(resourceName: "loading"))
        healthScoreLabel = iconLabel(text: viewModel.healthScore, numberOfLines: 2)
        
        spoonacularScoreImageView = UIImageView(image: #imageLiteral(resourceName: "spoonacular-score-51"))
        spoonacularScoreLabel = iconLabel(text: viewModel.spoonacularScore)
        
        pricePerServingImageView = UIImageView(image: #imageLiteral(resourceName: "cheap-1"))
        pricePerServingLabel = iconLabel(text: viewModel.pricePerServing, numberOfLines: 2)
        
        readyInMinutesImageView = UIImageView(image: #imageLiteral(resourceName: "fast-1"))
        readyInMinutesLabel = iconLabel(text: viewModel.pricePerServing, numberOfLines: 2)
        
        setupIconsWithLabelsStackView()
    }
    
    func iconLabel(text: String, numberOfLines: Int = 1) -> UILabel{
        let iconLabel = UILabel()
        iconLabel.text = text
        iconLabel.adjustsFontSizeToFitWidth = true
        iconLabel.minimumScaleFactor = 0.5
        iconLabel.numberOfLines = numberOfLines
        return iconLabel
    }
    
    func setupIconsWithLabelsStackView() {
        let stackviewAggregateLikes = UIStackView(arrangedSubviews: [
            aggregateLikesImageView, aggregateLikesLabel
        ])
        stackviewAggregateLikes.axis = .vertical
        stackviewAggregateLikes.alignment = .center
    
        let stackSpoonacularScore = UIStackView(arrangedSubviews: [
            spoonacularScoreImageView, spoonacularScoreLabel
        ])
        stackSpoonacularScore.axis = .vertical
        stackSpoonacularScore.alignment = .center
        
        let stackhealthScore = UIStackView(arrangedSubviews: [
            healthScoreImageView,healthScoreLabel
        ])
        stackhealthScore.axis = .vertical
        stackhealthScore.alignment = .center
        
        let stackPricePerServing = UIStackView(arrangedSubviews: [
            pricePerServingImageView, pricePerServingLabel,
        ])
        stackPricePerServing.axis = .vertical
        stackPricePerServing.alignment = .center
        
        let stackReadyInMinutes = UIStackView(arrangedSubviews: [
            readyInMinutesImageView,readyInMinutesLabel
        ])
        stackReadyInMinutes.alignment = .center
        stackReadyInMinutes.axis = .vertical
        
        stackViewIconsLabels = UIStackView(arrangedSubviews: [
            stackviewAggregateLikes,stackhealthScore,stackSpoonacularScore,
            stackPricePerServing,stackReadyInMinutes
        ])
        stackViewIconsLabels.distribution = .fillEqually
        stackViewIconsLabels.spacing = 10
        scrollView.addSubview(stackViewIconsLabels)
    }
    
    func setupTitleAndSummary() {
        titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        scrollView.addSubview(titleLabel)
        
        summaryLabel = UILabel()
        summaryLabel.numberOfLines = 0
        summaryLabel.text = viewModel.summary
        scrollView.addSubview(summaryLabel)
    }
    
    func setupDietsCuisinesDishTypes() {
        dietsLabel = dietsCuisinesDishTypesLabel(text: viewModel.diets)
        cuisinesLabel = dietsCuisinesDishTypesLabel(text: viewModel.cuisines)
        dishTypesLabel = dietsCuisinesDishTypesLabel(text: viewModel.dishTypes)
        
        scrollView.addSubview(dietsLabel)
        scrollView.addSubview(cuisinesLabel)
        scrollView.addSubview(dishTypesLabel)
    }
    
    func dietsCuisinesDishTypesLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 2
        return label
    }
   
    func setupIngredientsLabels() {
        stackViewIngredientsLabels  = UIStackView()
        stackViewIngredientsLabels.axis = .vertical
        for ingredientString in viewModel.ingredients.value {
            let label = UILabel()
            label.text = ingredientString
            label.numberOfLines = 0
            self.stackViewIngredientsLabels.addArrangedSubview(label)
        }
        self.scrollView.addSubview(self.stackViewIngredientsLabels)
        
        viewModel.ingredients.bindListener { (ingredients) in
            for (index,ingredientString) in ingredients.enumerated() {
                (self.stackViewIngredientsLabels.arrangedSubviews[index] as! UILabel).text = ingredientString
            }
        }
    }
    
    func setupServingsStepperAndLabel() {
        stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 50
        stepper.value = viewModel.servings
        stepper.addTarget(self, action: #selector(servingsStepperValueChanged(stepper:)), for: .valueChanged)
        
        servingsLabel = UILabel()
        servingsLabel.text = viewModel.servingsString.value
        servingsLabel.layer.cornerRadius = 10
        servingsLabel.layer.borderWidth = 1
        servingsLabel.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        viewModel.servingsString.bindListener { [unowned self] (servingsString) in
            self.servingsLabel.text = servingsString
        }
        servingsStepperAndLabelStackView = UIStackView(arrangedSubviews: [stepper, servingsLabel])
        servingsStepperAndLabelStackView.spacing = 10
        
        scrollView.addSubview(servingsStepperAndLabelStackView)
    }
    
    func setupButtonSourceOfRecipe() {
        sourceUrlButton = UIButton()
        sourceUrlButton.backgroundColor = #colorLiteral(red: 0, green: 0.6163546954, blue: 0.01877258797, alpha: 1)
        sourceUrlButton.setTitle("Source", for: .normal)
        sourceUrlButton.addTarget(self, action: #selector(goToSource), for: .touchUpInside)
        scrollView.addSubview(sourceUrlButton)
    }

    
    
    @objc func didTapOnRecipeImage(){
        if imageViewIsselected {
            scrollView.bringSubviewToFront(imageView)
            UIView.animate(withDuration: 0.2) {  [self] in
                imageView.layer.cornerRadius = 10
                imageViewLeadingAnchor.isActive = false
                imageViewTrailingAnchor.isActive = false
                imageViewTopAnchor.isActive = false
                imageViewLeadingAnchor = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10)
                imageViewTrailingAnchor = imageView.trailingAnchor.constraint(equalTo: stackViewTags.leadingAnchor,constant: -10)
                imageViewTopAnchor = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10)
                imageViewTopAnchor.isActive = true
                imageViewTrailingAnchor.isActive = true
                imageViewLeadingAnchor.isActive = true
                view.layoutIfNeeded()
            } completion: { (isAnimationEnd) in
                if isAnimationEnd {
                    self.imageViewIsselected.toggle()
                }
            }
        } else {
            scrollView.bringSubviewToFront(imageView)
            UIView.animate(withDuration: 0.2) {  [self] in
                imageView.layer.cornerRadius = 0
                imageViewTopAnchor.isActive = false
                imageViewLeadingAnchor.isActive = false
                imageViewTrailingAnchor.isActive = false
                imageViewTopAnchor = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
                imageViewLeadingAnchor = imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                imageViewTrailingAnchor = imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                imageViewTopAnchor.isActive = true
                imageViewTrailingAnchor.isActive = true
                imageViewLeadingAnchor.isActive = true
                view.layoutIfNeeded()
            } completion: { (isAnimationEnd) in
                if isAnimationEnd {
                    self.imageViewIsselected.toggle()
                }
            }
        }
    }
    
    @objc func goToSource() {
        let sourceOfRecipesVC = SourceOfRecipeViewController()
        sourceOfRecipesVC.viewModel = viewModel.viewModelForSourceOfRecipeViewController()
        navigationController?.pushViewController(sourceOfRecipesVC, animated: true)
        print("goooo")
    }
    
    @objc func servingsStepperValueChanged(stepper: UIStepper) {
        viewModel.servings = stepper.value
        print(stepper.value)
    }
    
    func setupUIConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackViewTags.translatesAutoresizingMaskIntoConstraints = false
        stackViewIconsLabels.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.translatesAutoresizingMaskIntoConstraints  = false
        dietsLabel.translatesAutoresizingMaskIntoConstraints = false
        cuisinesLabel.translatesAutoresizingMaskIntoConstraints = false
        dishTypesLabel.translatesAutoresizingMaskIntoConstraints = false
        stackViewIngredientsLabels.translatesAutoresizingMaskIntoConstraints = false
        servingsStepperAndLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        sourceUrlButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageViewTopAnchor = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10)
        imageViewLeadingAnchor = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10)
        imageViewTrailingAnchor = imageView.trailingAnchor.constraint(equalTo: stackViewTags.leadingAnchor,constant: -10)
        imageViewHeightAnchor = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16)
        
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: .horizontal)
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackViewTags.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            stackViewTags.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageViewTopAnchor,
            imageViewLeadingAnchor,
            imageViewTrailingAnchor,
            imageViewHeightAnchor,
            
            spoonacularScoreImageView.heightAnchor.constraint(equalToConstant: 30),
            spoonacularScoreImageView.widthAnchor.constraint(equalToConstant: 30),
            healthScoreImageView.heightAnchor.constraint(equalToConstant: 30),
            healthScoreImageView.widthAnchor.constraint(equalToConstant: 30),
            aggregateLikesImageView.heightAnchor.constraint(equalToConstant: 30),
            aggregateLikesImageView.widthAnchor.constraint(equalToConstant: 30),
            pricePerServingImageView.heightAnchor.constraint(equalToConstant: 30),
            pricePerServingImageView.widthAnchor.constraint(equalToConstant: 30),
            readyInMinutesImageView.heightAnchor.constraint(equalToConstant: 30),
            readyInMinutesImageView.widthAnchor.constraint(equalToConstant: 30),
            
            stackViewIconsLabels.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            stackViewIconsLabels.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackViewIconsLabels.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: stackViewIconsLabels.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dietsLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 10),
            dietsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dietsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dishTypesLabel.topAnchor.constraint(equalTo: dietsLabel.bottomAnchor, constant: 10),
            dishTypesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dishTypesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cuisinesLabel.topAnchor.constraint(equalTo: dishTypesLabel.bottomAnchor, constant: 10),
            cuisinesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cuisinesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            servingsStepperAndLabelStackView.topAnchor.constraint(equalTo: cuisinesLabel.bottomAnchor, constant: 20),
            servingsStepperAndLabelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            stackViewIngredientsLabels.topAnchor.constraint(equalTo: servingsStepperAndLabelStackView.bottomAnchor, constant: 10),
            stackViewIngredientsLabels.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackViewIngredientsLabels.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sourceUrlButton.topAnchor.constraint(equalTo:  stackViewIngredientsLabels.bottomAnchor, constant: 20),
            sourceUrlButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sourceUrlButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sourceUrlButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
}

extension DetailRecipeViewController: UIScrollViewDelegate {
    
}
