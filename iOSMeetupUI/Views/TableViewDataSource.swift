//
//  TableViewDataSource.swift
//  iOSMeetupUI
//
//  Created by George Kaimakas on 7/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

public protocol BindableDataSource: NSObject {
    associatedtype SectionIdentifier: Hashable
    associatedtype ItemIdentifier: Hashable
    
    func apply(_ snaphsot: [(SectionIdentifier, [ItemIdentifier])], animatingDifferences: Bool, completion: (() -> Void)?)
}

extension UITableViewDiffableDataSource: BindableDataSource {
    public typealias SectionIdentifier = SectionIdentifierType
    public typealias ItemIdentifier = ItemIdentifierType
    
    public func apply(_ snaphsot: [(SectionIdentifier, [ItemIdentifier])],
                      animatingDifferences: Bool = true,
                      completion: (() -> Void)?) {
        var snap = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
        
        for entry in snaphsot {
            snap.appendSections([entry.0])
            snap.appendItems(entry.1, toSection: entry.0)
        }
        
        self.apply(snap, animatingDifferences: animatingDifferences, completion: completion)
    }
}

public extension Reactive where Base: BindableDataSource {
    func apply(animatingDifferences: Bool = true) -> BindingTarget<[(Base.SectionIdentifier, [Base.ItemIdentifier])]> {
        return makeBindingTarget { (dataSource, snapshot) in
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: nil)
        }
    }
}

public final class TableViewDataSource<SectionIdentifier: Hashable, ItemIdentifier: Hashable>
: UITableViewDiffableDataSource<SectionIdentifier, ItemIdentifier> {
    
    let sections: Atomic<[SectionIdentifier]> = .init([])
    
    public func sectionIdentifer(at section: Int) -> SectionIdentifier {
        return sections.modify { $0[section] }
    }
    
    public override func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        
        sections.modify { $0 = snapshot.sectionIdentifiers }
        super.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }
}
