//
//  Property.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/11/21.
//

import Foundation

struct CapInfoPage: Hashable, Codable {
    var name: String
    var image: String
    
    public var capabilities: [eNkMAIDCapability]
}
