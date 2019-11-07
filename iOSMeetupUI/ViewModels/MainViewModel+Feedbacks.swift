//
//  MainViewModel+Feedbacks.swift
//  iOSMeetupUI
//
//  Created by George Kaimakas on 7/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import iOSMeetupCore
import ReactiveFeedback
import ReactiveSwift

extension MainViewModel {
    enum Feedbacks {
        static func whenExecutingAction(_ signal: Signal<Action, Never>) -> Feedback<State, Event> {
            .init(predicate: { $0.context != Context.loading }) { _ -> Signal<Event, Never> in
                func actionToEvent(action: Action) -> Event {
                    switch action {
                    case .fetchPosts:
                        return .fetchPosts
                    }
                }
                
                return signal
                    .map(actionToEvent(action:))
            }
        }
        
        static func whenFetchingPosts(_ postProvider: PostProviderProtocol) -> Feedback<State, Event> {
            .init(skippingRepeated: { $0 }, effects: { state -> SignalProducer<Event, Never> in
                guard case state.context = Context.loading else {
                    return .empty
                }
                
                let limit = 20
                let newPage = state.posts.count / limit
                
                func postsToEvent(_ posts: [Post]) -> Event {
                    return Event.fetchPostsSucceeded(posts)
                }
                
                func errorToEvent(_ err: CoreError) -> SignalProducer<Event, Never> {
                    .init(value: .fetchPostsFailed(err))
                }
                
                return postProvider
                    .fetchPosts(page: newPage + 1, limit: limit)
                    .map(postsToEvent)
                    .flatMapError(errorToEvent)
            })
        }
    }
}
