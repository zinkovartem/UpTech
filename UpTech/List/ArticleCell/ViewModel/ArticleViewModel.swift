//
//  ArticleViewModel.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa
import RxSwift

class ArticleViewModel: ArticleViewModelProtocol {
    
    var articleImage = BehaviorRelay<UIImage?>(value: nil)
    var articleTitle: String
    var articleDescription: String
    var articleContent: String?
    var articleDate: Date?
    
    private let disposeBag = DisposeBag()
    
    required init(_ model: ArticleModelProtocol) {
        articleTitle = model.title
        articleDescription = model.description
        articleDate = model.publishedAt
        articleContent = model.content
        
        model.imageData.asObservable().subscribe(onNext: { [weak self] data in
            if let data = data {
                self?.articleImage.accept(UIImage(data: data))
            }
        }).disposed(by: disposeBag)
    }
}
