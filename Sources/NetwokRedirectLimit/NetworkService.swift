//
//  NetworkService.swift
//  NetworkLimitationsIOS
//
//  Created by Chanoch M on 13/02/2020.
//  Copyright © 2020 cdmTech. All rights reserved.
//

import Foundation

public protocol NetworkServiceDelegate:AnyObject{
    func didFinishLoadRequest(response: ServerResponse<String>)
}

@available(iOS 11.0, *)
public class NetworkService:NSObject {
    
    private let networkLimitConfig:NetworkLimitConfig
    private var stringFromServerData:String?
    
    weak var delegate:NetworkServiceDelegate?
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration,
                          delegate: self, delegateQueue: nil)
    }()
    
    
    
    
    init(networkLimitConfig:NetworkLimitConfig) {
        self.networkLimitConfig = networkLimitConfig
        super.init()
    }
    
    @discardableResult
    func startLoad() -> URLSessionDataTask {
        let url = URL(string: self.networkLimitConfig.stringURL)!
        self.stringFromServerData = ""
        let task = session.dataTask(with: url)
        return task
    }
        
    private func getTextFromServer(){
        startLoad().resume()
    }
}

@available(iOS 11.0, *)
extension NetworkService:URLSessionDelegate, URLSessionTaskDelegate{
    
    fileprivate func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode),
            let mimeType = response.mimeType,
            mimeType == "application/json" else {
            completionHandler(.cancel)
            return
        }
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                if let names = json["names"] as? String {
                    self.stringFromServerData = names
                }else{
                   delegate?.didFinishLoadRequest(response: .error(customError: .serializationError))
                }
            }
        } catch {
            delegate?.didFinishLoadRequest(response: .error(customError: .serializationError))
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error = error {
                //TODO check casting
                self.delegate?.didFinishLoadRequest(response: .error(systemError: error))
            }
            else if let stringData = self.stringFromServerData {
                delegate?.didFinishLoadRequest(response: .success(stringData))
            }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
    }
}


public class NetworkLimitConfig{
    let numberOffRedirectAlows:Int
    let stringURL:String
    init(numberOffRedirectAlows:Int, stringURL:String) {
        self.numberOffRedirectAlows = numberOffRedirectAlows
        self.stringURL = stringURL
    }
}


public enum ServerResponse<T> {
    case success(T)
    case error(customError: NetworkLimitError)
    case error(systemError: Error)
}


public enum NetworkLimitError:Error{
    case statusCodeError(Int)
    case typeError
    case serializationError
}

extension NetworkLimitError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .statusCodeError(let code):
            return "return from server with status error code: \(code)"
        case .typeError:
            return "app could not retrieve data because the expected application/type not retrieved"
        case .serializationError:
            return "cannot parse the retrived object"
        }
    }
}
