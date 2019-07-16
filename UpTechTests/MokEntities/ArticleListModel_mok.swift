//
//  ArticleListModel_mok.swift
//  UpTechTests
//
//  Created by A.Zinkov on 7/16/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa
@testable import UpTech

class ArticleListModel_mok: ArticleListModelProtocol {
    var articleModels = BehaviorRelay<[ArticleModel]>(value: [])
    
    var pagesHasBeenReloaded: Int = 0
    var newPagesHasBennLoaded: Int = 0
    
    func reloadPages() {
        pagesHasBeenReloaded += 1
    }
    
    func loadNewPage() {
        newPagesHasBennLoaded += 1
    }
}
