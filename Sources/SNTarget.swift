//
//  SNTarget.swift
//  SimpleNetworkClient
//
//  Created by AlexD on 17/10/2022.
//

import Foundation
import Alamofire

public protocol SNTargetType {
    var path: String { get }
    var method: SNHttpMethod { get }
    var params: [String: Any]? { get }
    var headers: [String: String] { get }
    var encoding: SNEncodingMethod { get }
}

public struct SNDynamicTargetType: SNTargetType {
    
    var baseUrl: URL?
    
    var subTarget: SNTargetType
    
    public var encoding: SNEncodingMethod {
        return subTarget.encoding
    }
    
    public var params: [String: Any]? {
        return subTarget.params
    }
    
    public var path: String {
        return subTarget.path
    }
    
    public var method: SNHttpMethod {
        return subTarget.method
    }
    
    public var headers: [String : String] {
        return subTarget.headers
    }
}
