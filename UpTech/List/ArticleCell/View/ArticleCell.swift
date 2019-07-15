//
//  ArticleCell.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxSwift
import RxCocoa

class ArticleCell: UITableViewCell {
    
    static let reuseIdentifier = "ArticleCell"
    static let cellHeight: CGFloat = 120
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionTextView: UITextView!
    @IBOutlet weak var articleDateLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        articleImageView.image = nil
        articleTitleLabel.text = nil
        articleDescriptionTextView.text = nil
        articleDateLabel.text = nil
    }
    
    func setup(with viewModel: ArticleViewModelProtocol) {
        
        articleTitleLabel.text = viewModel.articleTitle
        articleDescriptionTextView.text = viewModel.articleDescription
        
        if let articleDate = viewModel.articleDate {
            let formatted = DateFormatter()
            formatted.dateFormat = "dd MMMM yyyy"
            articleDateLabel.text = "Date: \(formatted.string(from: articleDate))"
        }
        
        viewModel.articleImage.asObservable().subscribe(onNext: { [weak self] image in
            guard let wself = self else { return }
            
            wself.articleImageView.image = image?.resizeImage(targetSize: wself.articleImageView.bounds.size)
        }, onError: { [weak self] error in
            self?.articleImageView.image = nil
        }).disposed(by: disposeBag)
    }
}
