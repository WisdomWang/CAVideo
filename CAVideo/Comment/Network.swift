//
//  Network.swift
//  CAVideo
//
//  Created by Cary on 2019/8/28.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import Moya
import HandyJSON
import PKHUD

let LoadingPlugin = NetworkActivityPlugin { (type,target) in
    switch type {
    case .began:
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:100.0, height: 100.0)))
        PKHUD.sharedHUD.dimsBackground = true
        PKHUD.sharedHUD.show()
        break
    case .ended:
        PKHUD.sharedHUD.hide(animated: true)
        break
    }
}

let timeoutClosure = { (endpoint:Endpoint,closure:MoyaProvider<MoyaApi>.RequestResultClosure) ->Void in
    
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let ApiProvider = MoyaProvider<MoyaApi>(requestClosure: timeoutClosure)
let ApiLoadingProvider = MoyaProvider<MoyaApi>(requestClosure: timeoutClosure, plugins: [LoadingPlugin])

enum MoyaApi {
    
    case index(vsize: String)
    case movie(id: String, vsize: String)
    case more(page: String, size: String, ztid: String)
    case movieMore(page: String, size: String, id: String)
    case search(key: String, page: String, size: String)
    case show(id: String)
    
}

extension MoyaApi:TargetType {
    
    var baseURL: URL {return URL(string: "https://mjappaz.yefu365.com")!}
    
    var path:String {
        switch self {
        case .index: return "/index.php/app/ios/topic/index"
        case .movie: return "/index.php/app/ios/type/index"
        case .show: return "/index.php/app/ios/vod/show"
        default : return "/index.php/app/ios/vod/index"
        }}
    
    var method: Moya.Method {return .get}
    
    var task: Task {
        var parmeters:[String:Any] = [:]
        switch self {
        case .index(let vsize):
            parmeters["vsize"] = vsize
        case .movie(let id,let vsize):
            parmeters["id"] = id
            parmeters["vsize"] = vsize
        case .more(let page, let size, let ztid):
            parmeters["page"] = page
            parmeters["size"] = size
            parmeters["ztid"] = ztid
        case .movieMore(let page, let size, let id):
            parmeters["page"] = page
            parmeters["size"] = size
            parmeters["id"] = id
        case .search(let key, let page, let size):
            parmeters["key"] = key
            parmeters["page"] = page
            parmeters["size"] = size
        case .show(let id):
            parmeters["id"] = id
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    var sampleData: Data {return "".data(using: String.Encoding.utf8)!}
    var headers: [String: String]? {
        return [
            "Accept": "*/*",
            "Accept-Encoding": "br, gzip, deflate",
            "Accept-Language": "en-CN;q=1, zh-Hans-CN;q=0.9",
            "Connection": "keep-alive",
            "Content-Type": "application/x-www-form-urlencoded;charset=utf8",
            "Host": "mjappaz.yefu365.com",
        ]
    }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}

extension MoyaProvider {
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ returnData: [T]?) -> Void)?) -> Cancellable? {
        
        return request(target, completion: { (result) in
            guard let completion = completion else { return }
            guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
                completion(nil)
                return
            }
            completion(returnData.data)
        })
    }
}

