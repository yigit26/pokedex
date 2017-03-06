//
//  Pokemon.swift
//  pokedex
//
//  Created by Yiğit Can Türe on 06/03/2017.
//
//

import Foundation


class Pokemon {
    fileprivate var _name : String!
    fileprivate var _pokedexId : Int!
    var name : String {
        return _name
    }
    
    var pokedexId : Int {
        return _pokedexId
    }
    
    init(name : String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}
