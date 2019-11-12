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
