//
//  SNTarget.swift
//  SimpleNetworkClient
//
//  Created by AlexD on 17/10/2022.
//

import Foundation
import Alamofire
import RxSwift
import RxRelay

enum SNHttpMethod {
    case post
    case get
}

enum SNEncodingMethod {
    case urlEncoding
    case jsonEncoding
}

protocol SNTargetType {
    var path: String { get }
    var method: SNHttpMethod { get }
    var params: [String: Any]? { get }
    var headers: [String: String] { get }
    var encoding: SNEncodingMethod { get }
}

struct SNDynamicTargetType: SNTargetType {
    
    var baseUrl: URL?
    
    var subTarget: SNTargetType
    
    var encoding: SNEncodingMethod {
        return subTarget.encoding
    }
    
    var params: [String: Any]? {
        return subTarget.params
    }
    
    var path: String {
        return subTarget.path
    }
    
    var method: SNHttpMethod {
        return subTarget.method
    }
    
    var headers: [String : String] {
        return subTarget.headers
    }
}



