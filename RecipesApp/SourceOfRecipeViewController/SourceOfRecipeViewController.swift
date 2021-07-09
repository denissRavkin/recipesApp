//
//  SourceOfRecipeViewController.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 22.02.2021.
//

import UIKit
import WebKit

class SourceOfRecipeViewController: UIViewController {
    var progressView: UIProgressView!
    var activityIndicator: UIActivityIndicatorView!
    var webView: WKWebView!
    var goBackButton: UIButton!
    var goForwardButton: UIButton!
    var viewModel: SourceOfRecipeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupUI()
        setupConstraints()
        activityIndicator.startAnimating()
    }
    
    func setupUI() {
        setupActivityIndicator()
        setupProgressView()
        setupWebView()
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func setupProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        view.addSubview(progressView)
    }
    
    func setupWebView() {
        webView = WKWebView()
        guard let urlRequest = viewModel.urlRequest else {
            return
        }
        view.addSubview(webView)
        webView.load(urlRequest)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func setupConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            progressView.progress = Float(webView.estimatedProgress)
            if progressView.progress == 1 {
                print("1")
            }
        default:
            break
        }
    }
}
