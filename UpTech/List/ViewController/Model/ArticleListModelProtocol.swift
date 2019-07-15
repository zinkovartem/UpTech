//
//  ArticleListModelProtocol.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa

protocol ArticleListModelProtocol {
    var articleModels: BehaviorRelay<[ArticleModel]> { get }

    func reloadPages()
    func loadNewPage()
}
