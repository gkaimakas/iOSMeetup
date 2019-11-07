//
//  Post.swift
//  iOSMeetupCore
//
//  Created by George Kaimakas on 6/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public struct Post {
    
    public let userId: Int
    public let id: Int
    public let title: String?
    public let body: String?
    
    public init(userId: Int,
                id: Int,
                title: String?,
                body: String?) {
        
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}

extension Post: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Post: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(userId)
        hasher.combine(title)
        hasher.combine(body)
    }
}

extension Post: Codable { }
