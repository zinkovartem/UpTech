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
    
    private var imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UpTech")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getAllArticles() -> [ArticleModel] {
        let request: NSFetchRequest<ArticleManagedObject> = ArticleManagedObject.fetchRequest()
        
        if let articleManagedObjects = try? persistentContainer.viewContext.fetch(request) {
            return articleManagedObjects.map { ArticleModel(from: $0) }
        }
        
        return []
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
            guard let entity = NSEntityDescription.entity(forEntityName: "ArticleManagedObject", in: context),
                let imagePath = self?.imagePath
                else { return }
            
            let newArticle = self?.getArticle(with: article.title, from: context) ?? NSManagedObject(entity: entity, insertInto: context)
            
            newArticle.setValue(article.title, forKey: "title")
            newArticle.setValue(article.content, forKey: "content")
            newArticle.setValue(article.description, forKey: "articleDescription")
            newArticle.setValue(article.publishedAt, forKey: "publishedAt")
            newArticle.setValue(article.title, forKey: "imageName")
            
            do {
                try article.imageData.value?.write(to: imagePath.appendingPathComponent(article.title))
                try context.save()
            } catch {
                print("false")
            }
        }
    }
}
