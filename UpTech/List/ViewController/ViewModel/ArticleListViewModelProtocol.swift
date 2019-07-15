//
//  ArticleListViewModelProtocol.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa

protocol ArticleListViewModelProtocol {
    var model: ArticleListModelProtocol { get }
    var articles: BehaviorRelay<[ArticleViewModel]> { get }
    
    init(_ model: ArticleListModelProtocol)
    func reloadPages()
    func loadNewPage()
}
