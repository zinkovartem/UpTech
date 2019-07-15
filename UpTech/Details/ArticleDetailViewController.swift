//
//  ArticleDetailViewController.swift
//  UpTech
//
//  Created by A.Zinkov on 7/14/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxSwift

class ArticleDetailViewController: UIViewController {
    
    static let identifier = "ArticleDetailViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var articleText: UITextView!
    
    private var viewModel: ArticleViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    func setup(with viewModel: ArticleViewModelProtocol) {
        self.viewModel = viewModel
        navigationItem.title = viewModel.articleTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleText.text = viewModel.articleContent
        viewModel.articleImage.asObservable().subscribe(onNext: { [weak self] image in
            guard let wself = self else { return }
            
            wself.imageView.image = image?.resizeImage(targetSize: wself.imageView.bounds.size)
        }).disposed(by: disposeBag)
    }
}
