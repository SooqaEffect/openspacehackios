//
//  NetworkManager.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

protocol NetworkManager {
    var session: URLSession { get }
    func makeUploadRequest<T: Decodable>(with request: URLRequest, decode: @escaping(Decodable) -> T?, completion: @escaping(NetworkResult<T, NetworkResponseError>) ->())
}

extension NetworkManager {
    typealias JSONCompletionHandler = (Decodable?, NetworkResponseError?) -> ()
    
    func makeUploadRequest<T: Decodable>(with request: URLRequest, decode: @escaping(Decodable) -> T?, completion: @escaping(NetworkResult<T, NetworkResponseError>) ->()) {
        let task = uploadDecodingTask(with: request, decodeType: T.self) { (json , error) in
            
            guard let jsonResponse = json else {
                if let errorResponse = error {
                    completion(.fail(errorResponse))
                } else {
                    completion(.fail(.invalidData))
                }
                return
            }
            if let value = decode(jsonResponse) {
                completion(.success(value))
            } else {
                completion(.fail(.jsonParsingFailure))
            }
        }
        task.resume()
    }
    
    private func uploadDecodingTask<T: Decodable>(with request: URLRequest, decodeType: T.Type, completionHandler completion: @escaping JSONCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFail)
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let genericModel = try JSONDecoder().decode(decodeType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        completion(nil, .jsonParsingFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseNotOK(statusCode: httpResponse.statusCode))
            }
        }
        
        return task
        
        
        //        let task = session.uploadTask(with: request, from: uploadingData) { (data, response, error) in
        //            guard let httpResponse = response as? HTTPURLResponse else {
        //                completion(nil, .requestFail)
        //                return
        //            }
        //            if httpResponse.statusCode == 200 {
        //                if let data = data {
        //                    do {
        //                        let genericModel = try JSONDecoder().decode(decodeType, from: data)
        //                        completion(genericModel, nil)
        //                    } catch {
        //                        completion(nil, .jsonParsingFailure)
        //                    }
        //                } else {
        //                    completion(nil, .invalidData)
        //                }
        //            } else {
        //                completion(nil, .responseNotOK(statusCode: httpResponse.statusCode))
        //            }
        //        }
        //        return task
        
    }
}

