//
//  ArticleListViewModel.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa
import RxSwift

class ArticleListViewModel: ArticleListViewModelProtocol {
    
    var model: ArticleListModelProtocol
    var articles = BehaviorRelay<[ArticleViewModel]>(value: [])
    
    private let disposeBag = DisposeBag()

    required init(_ model: ArticleListModelProtocol) {
        self.model = model
        
        model.articleModels.asObservable().subscribe(onNext: { [weak self] articleModels in
            self?.articles.accept(articleModels.map { ArticleViewModel($0) })
        }).disposed(by: disposeBag)
    }
    
    func reloadPages() {
        model.reloadPages()
    }
    
    func loadNewPage() {
        model.loadNewPage()
    }
}
