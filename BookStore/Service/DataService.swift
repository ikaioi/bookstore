//
//  DataService.swift
//  BookStore
//
//  Created by Kaio Dantas on 09/10/20.
//

import Foundation
import Alamofire

struct DataService {
    
    // MARK: - Services
    func requestBooksList(with searchText: String, maxResults:Int, startIndex:Int = 0, completion: @escaping (BooksResults?, Error?) -> ()) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let url = "https://www.googleapis.com/books/v1/volumes?q=\(searchText)&maxResults=\(maxResults)&startIndex=\(startIndex)"
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                    case .success( _):
                        do {
                            let books = try BooksResults(data: response.data!)
                            completion(books, nil)
                            return
                        } catch {
                            completion(nil, response.error)
                            return
                        }
                        
                        
                    case .failure( _):
                        if let error = response.error {
                            completion(nil, error)
                            return
                        }
                        break
                }
                
            }
    }
    
    
}
