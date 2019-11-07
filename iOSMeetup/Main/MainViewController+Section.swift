//
//  MainViewController+Section.swift
//  iOSMeetup
//
//  Created by George Kaimakas on 7/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import Foundation

extension MainViewController {
    enum Section {
        case title(header: String?, footer: String?)
        
        var id: String {
            switch self {
            case let .title(header, footer):
                return "title-\(header ?? "")-\(footer ?? "")"
            }
        }
    }
}

extension MainViewController.Section: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MainViewController.Section: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
