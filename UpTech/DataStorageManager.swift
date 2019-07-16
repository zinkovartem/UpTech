//
//  DataStorageManager.swift
//  UpTech
//
//  Created by A.Zinkov on 7/13/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import UIKit
import CoreData

class DataStorageManager: NSObject {
    
    public static let shared = DataStorageManager()
    private(set) var persistentContainer: NSPersistentContainer!

    override init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate // Considering - this will never crash
        persistentContainer = delegate.persistentContainer
    }
    
    func getAllArticles() -> [ArticleModel] {
        let request: NSFetchRequest<ArticleManagedObject> = ArticleManagedObject.fetchRequest()
        var articleModels: [ArticleModel] = []
        
        if let articleManagedObjects = try? persistentContainer.viewContext.fetch(request) {
            for articleMO in articleManagedObjects {
                let articleModel = ArticleModel(from: articleMO)
                articleModels.append(articleModel)
            }
        }
        
        return articleModels
    }
    
    func getArticle(with title: String, from context: NSManagedObjectContext) -> ArticleManagedObject? {
        let request: NSFetchRequest<ArticleManagedObject> = ArticleManagedObject.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title) // Considering title as ID of article
        
        if let foundedObjects = try? context.fetch(request) {
            return foundedObjects.first
        }
        
        return nil
    }
    
    func saveArticle(_ article: ArticleModel) {
        
        persistentContainer.performBackgroundTask { [weak self] context in
            guard let entity = NSEntityDescription.entity(forEntityName: "ArticleManagedObject", in: context) else { return }
            let newArticle = self?.getArticle(with: article.title, from: context) ?? NSManagedObject(entity: entity, insertInto: context)
            
            newArticle.setValue(article.title, forKey: "title")
            newArticle.setValue(article.content, forKey: "content")
            newArticle.setValue(article.description, forKey: "articleDescription")
            newArticle.setValue(article.publishedAt, forKey: "publishedAt")
            newArticle.setValue(article.imageData.value, forKey: "imageData")
            
            do {
                try context.save()
            } catch {
                print("false")
            }
        }
    }
}
