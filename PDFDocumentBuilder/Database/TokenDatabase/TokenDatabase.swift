//
//  TokenDatabase.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 22.01.2022.
//

import Foundation
import CoreData

final class TokenDatabase {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Token")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension TokenDatabase: TokenDB {
    func saveToken(token: Token) {
        let tokenEntity = TokenEntity(context: context)
        tokenEntity.access = token.access
        tokenEntity.refresh = token.refresh

        do {
            try context.save()
        } catch let error {
            print("Error when saving token: \(error.localizedDescription)")
        }
    }

    func getToken() -> TokenEntity? {
        let request: NSFetchRequest = TokenEntity.fetchRequest()

        guard let token = try? context.fetch(request).first else {
            print("There is no token in database")
            return nil
        }

        return token
    }
}
