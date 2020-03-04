//
//  RepositoriesVC.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 3/4/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import UIKit

final class RepositoriesVC: UIViewController, StateViewer, Storyboarded {
    
    var eventHandler: AnyEventHandler<RepositoriesState.Event>?

    typealias State = RepositoriesState
    typealias Event = RepositoriesState.Event

    //Outlets
    @IBOutlet weak var tableView: UITableView!

    //MARK:-
    var state: RepositoriesState = .initial
    var repos: [UserRepoResponse] = []

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applySkinning()

        eventHandler?.handle(event: .loadData)
    }
    //MARK:-
    public func render(state: RepositoriesState) {

        self.state = state

        switch state {
        case .loading:
            UIRouter.instance.showLoading(in: view)
        case .loadingError:
            UIRouter.instance.dismissLoading()
            print("login error")
        case .repositories(_):
            UIRouter.instance.dismissLoading()
            tableView.reloadData()
        default:
            UIRouter.instance.dismissLoading()
        }
    }
    
    //MARK:- Skinning
    private func applySkinning() {
        
        tableView.tableFooterView = UIView()
        title = "Repositories"
    }
}

//MARK:- UITableViewDataSource
extension RepositoriesVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.repositories().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryTableCell.self), for: indexPath) as! RepositoryTableCell

        let repos = state.repositories()

        cell.repoNameLabel.text = repos[indexPath.row].name

        return cell
    }
}

extension RepositoriesState {
    
    fileprivate func repositories() -> [UserRepoResponse] {

        switch self {
        case .repositories(let repos):
            return repos
        default:
            return []
        }
    }
}
