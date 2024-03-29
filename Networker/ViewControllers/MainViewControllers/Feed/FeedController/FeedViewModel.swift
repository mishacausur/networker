//
//  FeedViewModel.swift
//  Networker
//
//  Created by Misha Causur on 18.10.2021.
//

import Foundation
import FirebaseAuth

protocol FeedViewInput: AnyObject {
    func configureTableView(posts: [Post])
    func animatedAlpha()
}

protocol FeedViewOutput: Coordinating {
    
    var users: [UserProfile]? { get }
    var posts: [Post]? { get }
    func getContent()
    func like(index: Int, likes: Int)
    func unlike(index: Int, likes: Int)
    func signOut()
}

class FeedViewModel: FeedViewOutput {
    
    weak var viewInput: FeedViewInput?
    
    var coordinator: Coordinator?
    
    var posts: [Post]?
    
    var users: [UserProfile]?
    
    func getContent() {
        APIManager.shared.getData { [weak self] pos in
            guard let post = pos else { return }
            APIManager.shared.getContent(name: post) { posts in
                DispatchQueue.main.async {
                    guard self?.viewInput != nil else { return }
                    switch posts {
                    case .success(let posts):
                        if posts.count == pos?.count {
                            self?.viewInput?.configureTableView(posts: posts)
                        }
                    case .failure(_):
                        print("failure")
                    }
                }
            }
        }
    }
    
    func like(index: Int, likes: Int) {
        let post = "post\(index)"
        APIManager.shared.liked(post: post, likes: likes)
    }
    
    func unlike(index: Int, likes: Int) {
        let post = "post\(index)"
        APIManager.shared.unliked(post: post, likes: likes)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch let error {
            print(error)
        }
        coordinator?.eventOccurred(with: .start, with: nil)
    }
}
