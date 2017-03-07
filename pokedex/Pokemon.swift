//
//  Pokemon.swift
//  pokedex
//
//  Created by Yiğit Can Türe on 06/03/2017.
//
//

import Foundation
import Alamofire

class Pokemon {
    private var _name : String!
    private var _pokedexId : Int!
    private var _description : String!
    private var _type : String!
    private var _defense: String!
    private var _height : String!
    private var _weight : String!
    private var _attack : String!
    private var _nextEvolotionTxt : String!
    private var _nextEvolotionName : String!
    private var _nextEvolotionId : String!
    private var _nextEvolotionLevel : String!
    private var _pokemonURL : String!
    
    var description : String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type : String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense : String {
        if _defense == nil {
            _defense =  ""
        }
        return _defense
    }
    
    var height : String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight : String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack : String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolotionId : String {
        if _nextEvolotionId == nil{
            _nextEvolotionId = ""
        }
        return _nextEvolotionId
    }
    
    var nextEvolotionLevel : String {
        if _nextEvolotionLevel == nil{
            _nextEvolotionLevel = ""
        }
        return _nextEvolotionLevel
    }
    
    var nextEvolotionName : String {
        if _nextEvolotionName == nil{
            _nextEvolotionName = ""
        }
        return _nextEvolotionName
    }
    
    var nextEvolotionTxt : String {
        if _nextEvolotionTxt == nil{
            _nextEvolotionTxt = ""
        }
        return _nextEvolotionTxt
    }
    
    var name : String {
        return _name
    }
    
    var pokedexId : Int {
        return _pokedexId
    }
    
    init(name : String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed : @escaping DownloadComplete){
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let dict  = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String,String>], types.count > 0 {
                    var slash = ""
                    var strType = ""
                    for x in 0..<types.count {
                        if let name = types[x]["name"] {
                            strType.append(slash)
                            strType.append(name.capitalized)
                            slash = "/"
                        }
                    }
                    self._type = strType
                }else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>], descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        Alamofire.request("\(URL_BASE)\(url)").responseJSON(completionHandler: { (response) in
                            if let dic2 = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = dic2["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                    print(newDescription)
                                }
                            }
                            completed()
                        })
                    }
                }
                
                if let evo = dict["evolutions"] as? [Dictionary<String,AnyObject>], evo.count > 0 {
                    if let nextEvo = evo[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolotionName = nextEvo
                            if let uri = evo[0]["resource_uri"] {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon", with: "").replacingOccurrences(of: "/", with: "")
                                self._nextEvolotionId = newStr
                                if let lvlExist = evo[0]["level"] {
                                    if let lvl = lvlExist as? Int {
                                        self._nextEvolotionLevel = "\(lvl)"
                                    }
                                }else {
                                    self._nextEvolotionLevel = ""
                                }
                            }
                            
                        }
                        
                    }
                }
                
            }
            completed()
        }
    }
}

