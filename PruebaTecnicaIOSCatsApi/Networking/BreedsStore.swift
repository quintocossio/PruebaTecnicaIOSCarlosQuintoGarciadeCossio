//
//  BreedsStore.swift
//  PruebaTecnicaIOSCatsApi
//
//  Created by Quinto Cossio on 22/07/2022.
//

import Foundation

class BreedStore: NSObject {
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                                create: false)
            .appendingPathComponent("cats.json")


        //TO SEE THE DATA SAVED:  xcrun simctl get_app_container booted QuintoCossio.PruebaTecnicaIOSCatsApi data
    }
    
    static func save(cats: [Cat], completion: @escaping (Result<[Cat], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                
                let outfile = try fileURL()
                
                if FileManager.default.fileExists(atPath: outfile.path) {
                    guard let file = try? FileHandle(forReadingFrom: outfile) else {
                        return
                    }
                    var catsArray = try JSONDecoder().decode([Cat].self, from: file.availableData)
                    catsArray.append(contentsOf: cats)
                    let data = try JSONEncoder().encode(catsArray)
                    try data.write(to: outfile)
                    DispatchQueue.main.async {
                        completion(.success(catsArray))
                    }
                    
                } else {
                    
                    let data = try JSONEncoder().encode(cats)
                    try data.write(to: outfile)
                    DispatchQueue.main.async {
                        completion(.success(cats))
                    }
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    


    static func load(completion: @escaping (Result<[Cat], Error>) -> Void){
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let cats = try JSONDecoder().decode([Cat].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(cats))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

}

