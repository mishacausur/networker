//
//  FavoriteViewModel.swift
//  Networker
//
//  Created by Misha Causur on 18.10.2021.
//

import Foundation

protocol FavoriteViewInput: AnyObject {
   
}

protocol FavoriteViewOutput: Coordinating {
   
}

class FavoriteViewModel: FavoriteViewOutput {
    var coordinator: Coordinator?
}
