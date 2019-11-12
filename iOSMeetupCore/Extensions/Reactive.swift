//
//  Reactive.swift
//  iOSMeetupCore
//
//  Created by George Kaimakas on 12/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation
import ReactiveSwift


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
