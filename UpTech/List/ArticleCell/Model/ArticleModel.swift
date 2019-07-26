//
//  ArticleModel.swift
//  UpTech
//
//  Created by A.Zinkov on 7/12/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import RxCocoa

class ArticleModel: Decodable, ArticleModelProtocol {
    
    // MARK: Properties
    var title: String = ""
    var description: String = ""
    var content: String?
    var publishedAt: Date?
    var imageData = BehaviorRelay<Data?>(value: nil)
    
    init(from managedObject: ArticleManagedObject) {
        title = managedObject.title ?? ""
        description = managedObject.articleDescription ?? ""
        content = managedObject.content ?? ""
        publishedAt = managedObject.publishedAt
        
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(managedObject.imageName ?? "") {
            imageData.accept(try? Data(contentsOf: url))
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case content
        case publishedAt
        case imageData = "urlToImage"
    }
    
    required init(from decoder: Decoder) throws {
        do {
        let values = try decoder.container(keyedBy: ArticleModel.CodingKeys.self)
        
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        content = try? values.decode(String.self, forKey: .content)
        
        let publishedAtString = try? values.decode(String.self, forKey: .publishedAt)
        publishedAt = ISO8601DateFormatter().date(from: publishedAtString ?? "")
        
        let urlToImage = try values.decode(URL.self, forKey: .imageData)
        DispatchQueue.global(qos: .userInteractive).async {
            let data = try? Data(contentsOf: urlToImage)
            DispatchQueue.main.async {
                self.imageData.accept(data)
                DataStorageManager.shared.saveArticle(self)
            }
        }
        } catch {
            print("So sad :(")
        }
    }
}

struct NewsResponse: Decodable {
    var articles: [ArticleModel]
}
