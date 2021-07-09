//
//  NetworkManager.swift
//  RecipesApp
//
//  Created by Denis Ravkin on 05.02.2021.
//

import Foundation

class NetworkRequest {
    
    static func getDataTask<T: Decodable>(url: URL, completion: @escaping (T?)-> Void)  {
        
        URLSession.shared.dataTask(with: url) { (data, _ , _) in
            guard let data = data else { return }
            print("data ok")
            do {
                let recipesList = try JSONDecoder().decode(T.self, from: data)
                print("compl!!!!!")
                completion(recipesList)
            } catch {
                completion(nil)
                print("catch error")
                print(error)
            }
            
        }.resume()
    }
}
