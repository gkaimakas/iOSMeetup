//
//  CoreError.swift
//  iOSMeetupCore
//
//  Created by George Kaimakas on 6/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

public enum CoreError: Error {
    case unknown(Error)
}

extension CoreError: Equatable {
    public static func == (lhs: CoreError, rhs: CoreError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
}
