//
//  ArticleListViewModel_unitTests.swift
//  UpTechTests
//
//  Created by A.Zinkov on 7/16/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import XCTest
@testable import UpTech

class ArticleListViewModel_unitTests: XCTestCase {
    
    let mok_model = ArticleListModel_mok()
    lazy var listViewModel = ArticleListViewModel(mok_model)
    
    func testReloadPages() {
        
        let reloadPagesTimes = Int.random(in: 0...10)
        
        var i = 0
        while i < reloadPagesTimes {
            listViewModel.reloadPages()
            i += 1
        }
        
        XCTAssert(mok_model.pagesHasBeenReloaded == reloadPagesTimes)
    }
    
    func testLoadNewPage() {
        
        let loadNewPageTimes = Int.random(in: 0...10)
        
        var i = 0
        while i < loadNewPageTimes {
            listViewModel.loadNewPage()
            i += 1
        }
        
        XCTAssert(mok_model.newPagesHasBennLoaded == loadNewPageTimes)
    }
}
