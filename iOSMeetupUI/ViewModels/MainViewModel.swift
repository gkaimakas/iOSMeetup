//
//  MainViewModel.swift
//  iOSMeetupUI
//
//  Created by George Kaimakas on 6/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import iOSMeetupCore
import ReactiveFeedback
import ReactiveSwift

public final class MainViewModel {
    let lifetimeToken: Lifetime.Token
    let lifetime: Lifetime
    
    let state: Property<State>
    let (action, actionObserver) = Signal<Action, Never>.pipe()
    
    public let posts: Property<[PostRow]>
    
    public init(postProvider: PostProviderProtocol) {
        lifetimeToken = .init()
        lifetime = .init(lifetimeToken)
        
        let feedbacks = [
            Feedbacks.whenExecutingAction(action),
            Feedbacks.whenFetchingPosts(postProvider)
        ]
        
        state = .init(initial: .initial(),
                      scheduler: QueueScheduler.main,
                      reduce: Self.reduce,
                      feedbacks: feedbacks)
        
        posts = state.map(\.posts).map { $0.map(PostRow.init) }
    }
    
    deinit {
        lifetimeToken.dispose()
    }
    
    public func execute(action: Action) {
        actionObserver.send(value: action)
    }
    
    public func bindExecute() -> BindingTarget<Action> {
        .init(lifetime: lifetime) { [weak self] action in
            self?.execute(action: action)
        }
    }
}

extension MainViewModel {
    public struct State: Equatable {
        public static func == (lhs: MainViewModel.State, rhs: MainViewModel.State) -> Bool {
            lhs.context == rhs.context
                && lhs.error == rhs.error
                && lhs.posts == rhs.posts
        }
        
        static func initial() -> State {
            return .init(context: .initial,
                         posts: [])
        }
        
        let context: Context
        let posts: [Post]
        let error: CoreError?
        
        init(context: Context,
             posts: [Post],
             error: CoreError? = nil) {
            
            self.context = context
            self.posts = posts
            self.error = error
        }
        
        func with(context value: Context) -> Self {
            return .init(context: value,
                         posts: posts)
        }
        
        func with(posts value: [Post]) -> Self {
            return .init(context: context,
                         posts: self.posts + value)
        }
        
        func with(error: CoreError) -> Self {
            return .init(context: context,
                         posts: posts,
                         error: error)
        }
    }
    
    public enum Event {
        case fetchPosts
        case fetchPostsSucceeded([Post])
        case fetchPostsFailed(CoreError)
    }
}

extension MainViewModel {
    public static func reduce(state: State, event: Event) -> State {
        switch state.context {
        case .initial:
            return reduceInitial(state: state, event: event)
        case .loading:
            return reduceLoading(state: state, event: event)
        case .loaded:
            return reduceLoaded(state: state, event: event)
        }
    }
    
    public static func reduceInitial(state: State, event: Event) -> State {
        guard case state.context = Context.initial else {
            return state
        }
        
        switch event {
        case .fetchPosts:
            return state
                .with(context: .loading)
            
        default:
            return state
        }
    }
    
    public static func reduceLoading(state: State, event: Event) -> State {
        guard case state.context = Context.loading else {
            return state
        }
        
        switch event {
        case let .fetchPostsFailed(error):
            return state
                .with(context: .loaded)
                .with(error: error)
            
        case let .fetchPostsSucceeded(result):
            return state
                .with(context: .loaded)
                .with(posts: result)
        default:
            return state
        }
    }
    
    public static func reduceLoaded(state: State, event: Event) -> State {
        guard case state.context = Context.loaded else {
            return state
        }
        
        switch event {
        case .fetchPosts:
            return state
                .with(context: .loading)
        default:
            return state
        }
    }
}
