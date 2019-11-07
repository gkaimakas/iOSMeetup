//
//  MainViewController+Row.swift
//  iOSMeetup
//
//  Created by George Kaimakas on 7/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import iOSMeetupUI

extension MainViewController {
    enum Row {
        case post(MainViewModel.PostRow)
        
        var id: String {
            switch self {
            case let .post(row):
                return "post-\(row.id)"
            }
        }
    }
}

extension MainViewController.Row: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MainViewController.Row: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
