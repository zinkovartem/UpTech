//
//  ArticleListViewController.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa
import RxSwift

class ArticleListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var refreshControl = UIRefreshControl()
    private var articleViewModels: [ArticleViewModel] { return viewModel?.articles.value ?? [] }
    private var activityIndicator = UIActivityIndicatorView()
    private var viewModel: ArticleListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = ArticleListModel()
        viewModel = ArticleListViewModel(model)
        
        viewModel.articles
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                
                self.tableView.reloadData()
                if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
                if self.activityIndicator.isAnimating { self.activityIndicator.stopAnimating() }
        }).disposed(by: disposeBag)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadPages), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        activityIndicator.frame = view.frame
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
        
        reloadPages()
    }
    
    @objc func reloadPages() {
        viewModel.reloadPages()
    }
    
    // MARK: Private methods
    private func loadNewPage() {
        viewModel.loadNewPage()
    }
}

extension ArticleListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ArticleCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as? ArticleCell {
            cell.setup(with: articleViewModels[indexPath.row])
            
            return cell
        }
        
        return ArticleCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let articleViewModel = articleViewModels[safeIndex: indexPath.row],
            articleViewModel.articleContent != nil,
            let articleDetailVC = storyboard?.instantiateViewController(withIdentifier: ArticleDetailViewController.identifier) as? ArticleDetailViewController {
            
            articleDetailVC.setup(with: articleViewModel)
            navigationController?.pushViewController(articleDetailVC, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == articleViewModels.count {
            loadNewPage()
        }
    }
}
