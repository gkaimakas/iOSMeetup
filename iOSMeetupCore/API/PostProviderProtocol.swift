//
//  PostProviderProtocol.swift
//  iOSMeetupCore
//
//  Created by George Kaimakas on 6/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation
import ReactiveSwift

fileprivate func decode<T: Decodable>(data: Data, response: URLResponse) -> Result<T, CoreError> {
    fatalError()
}

public protocol PostProviderProtocol: class {
    func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], CoreError>
}

public final class PostProvider: PostProviderProtocol {
    let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], CoreError> {
        let request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=\(limit)")!)
        
        return session
            .reactive
            .data(with: request)
            .decode([Post].self)
    }
}

extension Signal where Value == (Data, URLResponse) {
    func decode<T: Decodable>(_ type: T.Type) -> Signal<T, CoreError> {
        
        mapError(CoreError.unknown)
            .map(\.0)
            .attemptMap { data -> Result<T, CoreError> in
                do {
                    let result = try JSONDecoder().decode(type, from: data)
                    return .success(result)
                } catch let err {
                    return .failure(CoreError.unknown(err))
                }
        }
    }
}

extension SignalProducer where Value == (Data, URLResponse) {
    func decode<T: Decodable>(_ type: T.Type) -> SignalProducer<T, CoreError> {
        lift { $0.decode(type) }
    }
}
