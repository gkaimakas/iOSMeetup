//
//  ViewController.swift
//  iOSMeetup
//
//  Created by George Kaimakas on 6/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import iOSMeetupCore
import iOSMeetupUI
import ReactiveCocoa
import ReactiveSwift
import SnapKit
import UIKit

class MainViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    let dataSource: TableViewDataSource<Section, Row>
    let viewModel: MainViewModel
    
    init(main: MainViewModel) {
        viewModel = main
        dataSource = .init(tableView: tableView,
                           cellProvider: MainViewController.cellProvider)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.reactive.title <~ viewModel
            .posts
            .map(\.count)
            .map { "\($0) Posts" }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        bindPaging()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bindDataSource()
    }
    
    
    fileprivate func bindPaging() {
        reactive.lifetime += viewModel.bindExecute() <~ tableView
            .reactive
            .isNearBottom(threshold: 50)
            .skipRepeats()
            .filter { $0 }
            .map(value: .fetchPosts)
    }
    
    fileprivate func bindDataSource() {
        reactive.lifetime += dataSource.reactive.apply(animatingDifferences: true) <~ viewModel
            .posts
            .map(rowsForDataSource)
            .producer
            .take(until: reactive.viewWillDisappear)
            .observe(on: UIScheduler())
    }
}

extension MainViewController {
    static func cellProvider(tableView: UITableView,
                             indexPath: IndexPath,
                             row: Row) -> UITableViewCell? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",
                                                 for: indexPath)
        switch row {
        case let .post(value):
            cell.textLabel?.text = value.body
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = value.title
        }
        return cell
        
    }
}

private func rowsForDataSource(_ rows: [MainViewModel.PostRow]) -> [(MainViewController.Section, [MainViewController.Row])] {
    [
        (
            MainViewController.Section.title(header: nil, footer: nil),
            rows.map(MainViewController.Row.post)
        )
    ]
    
}

