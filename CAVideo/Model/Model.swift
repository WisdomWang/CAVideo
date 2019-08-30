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

struct AnotherResponseData<T: HandyJSON>: HandyJSON {
    var code: Int = 0
    var data: T?
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

struct PlotMessageData:HandyJSON {
    
    var addtime: String!
    var cid: String!
    var cion: String!
    var cname: String!
    var commentCount: Int!
    var daoyan: String!
    var dhits: Int!
    var diqu: String!
    var fid: String!
    var hits: String!
    var id: String!
    var info: String!
    var look: Int!
    var looktime: Int!
    var name: String!
    var pf: String!
    var pic: String!
    var shareurl: String!
    var state: String!
    var text: String!
    var type: String!
    var vip: String!
    var year: String!
    var yuyan: String!
    var zhuyan: String!
    var zu: [Zu]!
}

struct Zu:HandyJSON {
    var count: Int!
    var id: Int!
    var ji: [Ji]!
    var ly: String!
    var name: String!
}

struct Ji:HandyJSON {
    var ext: String!
    var id: Int!
    var name: String!
    var purl: String!
}
