//
//  LocalState.swift
//  PruebaTecnicaIOSCatsApi
//
//  Created by Quinto Cossio on 22/07/2022.
//

import Foundation

public class LocalState {
    
    private enum Keys: String{
        case currentIndex
    }
    
    public static var currentIndex: Int {
        get{
            return UserDefaults.standard.integer(forKey: Keys.currentIndex.rawValue)
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: Keys.currentIndex.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
