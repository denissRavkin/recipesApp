//
//  SourceOfRecipeViewModel.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 22.02.2021.
//

import Foundation

class SourceOfRecipeViewModel: SourceOfRecipeViewModelProtocol {
    var urlString: String
    
    var urlRequest: URLRequest? {
        print(urlString)
        checkingConnectionHttps()
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func checkingConnectionHttps() {
        if urlString[urlString.index(urlString.startIndex, offsetBy: 4)] != "s" {
            urlString.insert("s", at: urlString.index(urlString.startIndex, offsetBy: 4))
            print(urlString)
        }
    }
}
