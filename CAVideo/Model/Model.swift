//
//  Model.swift
//  CAVideo
//
//  Created by Cary on 2019/8/28.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import HandyJSON


extension Array:HandyJSON{}

struct ResponseData<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var data: [T]?
}

struct MainData: HandyJSON {
    var ad: Int!
    var id: String!
    var name: String!
    var pic: String!
    var url: String!
    var vod: [Vod]?
}

struct Vod: HandyJSON {
    var cion: String!
    var hits: String!
    var id: String!
    var info: String!
    var name: String!
    var pf: String!
    var pic: String!
    var state: String!
    var type: String!
    var vip: String!
}
