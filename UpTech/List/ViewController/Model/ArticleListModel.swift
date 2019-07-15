//
//  ArticleListModel.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa
import RxSwift
import Reachability

class ArticleListModel: ArticleListModelProtocol {
    
    let articleModels = BehaviorRelay<[ArticleModel]>(value: [])
    private let disposeBag = DisposeBag()
    private var pageNumber = 1
    private let reachability = Reachability()
    
    func reloadPages() {
        pageNumber = 1
        if (reachability?.connection ?? .none) != Reachability.Connection.none { // Didn't get why it's not working when via session - connection appears :(
            reloadPagesFromNetwork()
        } else {
            reloadPagesFromDatabase()
        }
    }
    
    func loadNewPage() {
        pageNumber += 1
        if (reachability?.connection ?? .none) != Reachability.Connection.none {
            loadNewPageFromNetwork()
        }
    }
    
    // MARK: Private methods
    private func reloadPagesFromDatabase() {
        articleModels.accept(DataStorageManager.shared.getAllArticles())
    }
    
    private func reloadPagesFromNetwork() {
        NetworkManager.shared.getNewsResponse(with: "Apple", forPage: pageNumber).subscribe(onNext: { [weak self] response in
            
            guard let wself = self else { return }
            wself.articleModels.accept(response.articles)
            
        }).disposed(by: disposeBag)
    }
    
    private func loadNewPageFromNetwork() {
        NetworkManager.shared.getNewsResponse(with: "Apple", forPage: pageNumber).subscribe(onNext: { [weak self] response in
            
            guard let wself = self else { return }
            wself.articleModels.accept(wself.articleModels.value + response.articles)
            
        }).disposed(by: disposeBag)
    }
}
