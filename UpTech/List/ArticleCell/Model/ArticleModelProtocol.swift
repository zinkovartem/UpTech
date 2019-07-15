//
//  ArticleModelProtocol.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa

protocol ArticleModelProtocol: Decodable {
    var title: String { get }
    var description: String { get }
    var content: String? { get }
    var publishedAt: Date? { get }
    var imageData: BehaviorRelay<Data?> { get }
}
