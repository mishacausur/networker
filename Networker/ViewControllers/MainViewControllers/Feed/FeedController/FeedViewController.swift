//
//  FeedViewController.swift
//  Networker
//
//  Created by Misha Causur on 18.10.2021.
//

import UIKit
import FirebaseDatabase

class FeedViewController: UIViewController, ViewController {
    
    typealias RootView = FeedView
    
    var viewModel: FeedViewOutput
    
    init(viewModel: FeedViewOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        guard transitionCoordinator != nil else { return }
//        transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
//            print("-------------------------------------------------------")
//            print(context.transitionDuration)
//        }, completion: { context in
//
//        })
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view().signOutTapped = {
            self.viewModel.signOut()
        }
        view().toUser = { user in
            self.viewModel.coordinator?.eventOccurred(with: .toUser, with: user)
        }
        view().refresh = {
            self.viewModel.getContent()
        }
        viewModel.getContent()
    }
    
    override func loadView() {
        let view = FeedView()
        self.view = view
    }
}

extension FeedViewController: FeedViewInput {
    
    func configureTableView(posts: [Post]) {
        guard let users = viewModel.users else { return }
        view().animator()
        view().configureTableView(posts: posts, users: users)
        view().liked = { [weak self] (index, likes) in
            self?.viewModel.like(index: index, likes: likes)
        }
        view().disliked = { [weak self] (index, likes) in
            self?.viewModel.unlike(index: index, likes: likes)
        }
    }
    
    func animatedAlpha() {
        
    }
}
