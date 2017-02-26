//
//  Friends.swift
//  MBaasKitTest
//
//  Created by Timothy Barnard on 26/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import MBaaSKit

struct Friends: TBJSONSerializable {
    
    var name: String!
    var age: Int!
    var dob: String!
    var country: String!
    var county: String!
    
    init() {}
    
    init(name:String, age:Int, dob:String, country:String, county:String) {
        self.name = name
        self.age = age
        self.dob = dob
        self.country = country
        self.county = county
    }
    
    init(jsonObject: TBJSON) {
        
        self.name = jsonObject.tryConvert(forKey: "name")
        self.age = jsonObject.tryConvert(forKey: "age")
        self.dob = jsonObject.tryConvert(forKey: "dob")
        self.country = jsonObject.tryConvert(forKey: "country")
        self.county = jsonObject.tryConvert(forKey: "county")
    }
}
