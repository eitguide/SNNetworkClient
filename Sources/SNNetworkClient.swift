//
//  SNNetworkClient.swift
//  SimpleNetworkClient
//
//  Created by AlexD on 17/10/2022.
//

import Foundation
import Alamofire
import RxSwift

public protocol SNNetworkClient {
    func request<O: Decodable>(target: SNTargetType,
                               type: O.Type,
                               additionalHeaders: [String: String]) -> Observable<O>
    func request<O: Decodable>(target: SNTargetType,
                               type: O.Type) -> Observable<O>
}

public class SNNetworkClientImpl: SNNetworkClient {
    private let baseUrl: URL
    private let section: Session = Session.default
    
    private var config: URLSessionConfiguration {
        return URLSessionConfiguration.default
    }
    
    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    public func request<O>(target: SNTargetType, type: O.Type) -> RxSwift.Observable<O> where O : Decodable {
        return self.request(target: target, type: type, additionalHeaders: [:])
    }
    
    public func request<O: Decodable>(
        target: SNTargetType,
        type: O.Type,
        additionalHeaders: [String: String])
    -> Observable<O> {
        return Observable<O>.create { [weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            
            let dymamicTarget = SNDynamicTargetType(baseUrl: self.baseUrl, subTarget: target)
            guard let dymamicTargetURL = dymamicTarget.baseUrl else {
                return Disposables.create()
            }
             
            let httpMethod = dymamicTarget.method == .get
            ? HTTPMethod.get
            : HTTPMethod.post
            
            let enconding: ParameterEncoding = dymamicTarget.encoding == .jsonEncoding
            ? JSONEncoding.default
            : URLEncoding.default

            var headers = HTTPHeaders(additionalHeaders)
            for (key, value) in dymamicTarget.headers {
                headers.add(name: key, value: value)
            }
            
            let request = self.section.request(
                dymamicTargetURL.appendingPathComponent(dymamicTarget.path),
                method: httpMethod,
                parameters: dymamicTarget.params,
                encoding: enconding,
                headers: headers
            )
            .validate(statusCode: 200..<300)
            .cURLDescription { curl in
                debugPrint(curl)
            }
            .responseDecodable(of: type) { response in
                switch response.result {
                case .success(let object):
                    observer.onNext(object)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                if !request.isCancelled {
                    request.cancel()
                }
            }
        }
    }
}
