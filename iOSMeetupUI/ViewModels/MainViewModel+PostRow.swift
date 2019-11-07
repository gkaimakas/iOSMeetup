//
//  MainViewModel+PostRow.swift
//  iOSMeetupUI
//
//  Created by George Kaimakas on 7/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import iOSMeetupCore

extension MainViewModel {
    public struct PostRow {
        public let userId: Int
        public let id: Int
        public let title: String?
        public let body: String?
        
        init(_ post: Post) {
            userId = post.userId
            id = post.id
            title = post.title
            body = post.body
        }
    }
}
