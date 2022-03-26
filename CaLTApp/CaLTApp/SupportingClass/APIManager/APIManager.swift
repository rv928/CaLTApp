//
//  APIManager.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import Foundation
import Alamofire

fileprivate let AUTH_KEY = "75074abd-fd89-4b15-b9cb-041a15c237c9"

class APIManager {
    
    private var session: Session?
    let printResponse: Bool = true
    var endpoint: String = ""
    var method: HTTPMethod = .get
    fileprivate var host: String = "https://api.thecatapi.com"
    fileprivate var apiVersion: String = "/v1"
    
    static var uris: [endpointType: String] = [
        .fetchCatList: "/breeds"
    ]
    
    public enum endpointType: String {
        case fetchCatList = "fetchCatList"
        
        func method() -> HTTPMethod {
            switch self {
            case .fetchCatList:
                return .get
            }
        }
    }
    
    let headersCommon: HTTPHeaders = [
        "Accept": "application/json",
        "x-api-key": AUTH_KEY
    ]
    
    init(endpoint: APIManager.endpointType, timeoutIntervalForRequest: TimeInterval = 60, timeoutIntervalForResource: TimeInterval = 60) {
        self.endpoint = APIManager.uris[endpoint] ?? ""
        self.method = endpoint.method()
        self.createSessionManager(timeoutIntervalForRequest: timeoutIntervalForRequest,timeoutIntervalForResource: timeoutIntervalForResource)
    }
    
    private func createSessionManager(timeoutIntervalForRequest: TimeInterval, timeoutIntervalForResource: TimeInterval) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest // seconds
        configuration.timeoutIntervalForResource = timeoutIntervalForResource
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        self.session = Session(configuration: configuration)
    }
    
    public func call(parameters: [String:Any]?,
                     headersAdditional: [String:String]?,
                     encoding: ParameterEncoding?,
                     fail: @escaping (_ dataResponse: DataResponse<Data, AFError>?) -> (),
                     success: @escaping (_ data: Data?) -> ()) {
        self.networkOperation(method: self.method,
                              parameters: parameters,
                              headersAdditional: headersAdditional,
                              encoding: encoding,
                              fail: fail,
                              success: success)
    }
    
    private func networkOperation(method useMethod: HTTPMethod,
                                  parameters: [String:Any]?,
                                  headersAdditional: [String:String]?,
                                  encoding: ParameterEncoding?,
                                  isRequiredAccessToken: Bool = true,
                                  fail: @escaping (_ dataResponse: DataResponse<Data, AFError>?) -> (),
                                  success: @escaping (_ data: Data?) -> ()) {
        
        var headers = headersCommon
       
        var requestEncoding: ParameterEncoding
        
        if encoding != nil {
            requestEncoding = encoding!
        } else {
            requestEncoding = JSONEncoding.default
        }
        
        var url = host + apiVersion + endpoint
        
        var params: [String:Any]?
        
        switch useMethod {
        case .get:
            var apiParams = ""
            for (key, name) in parameters! {
                apiParams = apiParams + key + "=" + "\(name)" + "&"
            }
            if apiParams.hasSuffix("&") {
                apiParams = String(apiParams.dropLast())
            }
            if apiParams != "" {
                url = "\(url)?\(apiParams)"
            }
        default:
            params = parameters
        }
        
        if headersAdditional != nil {
            for (k, v) in headersAdditional! {
                headers[k] = v
            }
        }
        
        if self.printResponse {
            print("________________________________________________________")
            print("url:   \(url)")
            print("method:  \(method)")
            print("headers:   \(headers)")
            print("params:   \(params ?? [:])")
        }
        
        guard let urlEncoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            fail(nil)
            return
        }
        
        AF.request(urlEncoded, method: useMethod, parameters: params, encoding: requestEncoding, headers: headers).validate().responseData { (response) in
            
            switch response.result {
            case let .success(value):
                if response.response?.statusCode == 200 {
                    success(value)
                } else {
                    fail(response)
                }
            case .failure(_):
                fail(response)
            }
        }
        .responseString { response in
            switch response.result {
            case .success(let value):
                print("value**: \(value)")
            case .failure(let error):
                print(error)
            }
        }
    }
}
