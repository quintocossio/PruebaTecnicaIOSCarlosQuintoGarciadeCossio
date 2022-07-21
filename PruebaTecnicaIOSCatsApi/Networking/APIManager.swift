//
//  APIManager.swift
//  PruebaTecnicaIOSCatsApi
//
//  Created by Quinto Cossio on 21/07/2022.
//

import Foundation

protocol APIManageable: AnyObject {
    func fetchCatBreeds(completion: @escaping (Result<[Cat],NetworkError>) -> Void)
}

enum NetworkError: Error {
    case serverError
    case decodingError
}

class APIManager: APIManageable{
    
    func fetchCatBreeds(completion: @escaping (Result<[Cat],NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds") else {
            completion(.failure(.decodingError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                
                do {
                    let cats = try JSONDecoder().decode([Cat].self, from: data)
                    completion(.success(cats))
                    
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(.decodingError))
                    
                }
                
            }
            
        }.resume()
    }
    
    
}
