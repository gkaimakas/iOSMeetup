//
//  MainViewModel+Context.swift
//  iOSMeetupUI
//
//  Created by George Kaimakas on 6/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

extension MainViewModel {
    enum Context: Equatable {
        case initial
        case loading
        case loaded
    }
}
