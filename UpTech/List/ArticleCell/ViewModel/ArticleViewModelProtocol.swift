//
//  ArticleViewModelProtocol.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa

protocol ArticleViewModelProtocol {
    var articleImage: BehaviorRelay<UIImage?> { get }
    var articleTitle: String { get }
    var articleDescription: String { get }
    var articleContent: String? { get }
    var articleDate: Date? { get }

    init(_ model: ArticleModelProtocol)
}
