//
//  DBHelper.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 30.11.2021.
//

import FirebaseAuth
import FirebaseFirestore

struct DBHelper {
    
    static let db = Firestore.firestore()
    
    static var userTasks = Set<Task>()
    
    static var userInfo: UserInfo?
    
    static let userId = Auth.auth().currentUser?.uid
    
    static func saveDataTo(collection: String, documentName: String, data:[String: Any]) {
        db.collection(collection)
            .document(documentName)
            .setData(data) { error in
                if let e = error {
                    print("There was an issue saving data to Firestore \(e)")
                } else {
                    print("Successfully saving data to collection: \(collection)")
                }
            }
    }
    
    static func getOnlyTodaysTask() -> [Task]? {
        if userTasks.count != 0 && filterTaskByToday().count > 0 {
            return filterTaskByToday()
        } else {
            return nil
        }
    }
    
    private static func filterTaskByToday() -> [Task] {
        return userTasks.filter { task in
            let component = DateHelper.getMonthAndDay(date: task.dateBegin)
            let today = DateHelper.getMonthAndDay(date: Date())
            
            let result = component.month == today.month! && component.day! == today.day
            return result
        }
    }
    
    static func saveDataToSubcollection(collection: String, documentName: String, subCollection: String, data:[String: Any]) {
        userTasks.removeAll()
        
        db.collection(collection)
            .document(documentName)
            .collection(subCollection)
            .document()
            .setData(data) { error in
                if let e = error {
                    print("There was an issue saving data to Firestore \(e)")
                } else {
                    print("Successfully saving data to collection: \(collection) and subcollection \(subCollection)")
                }
            }
    }
    
    static func reloadUserTasks(completion:@escaping(() -> ())) {
        userTasks.removeAll()
        
        db.collection(K.FStore.Collection.tasks)
            .document(userId!)
            .collection(K.FStore.Collection.userTasks)
            .addSnapshotListener({ querySnapshot, error in
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if  let id = data[K.FStore.Field.id] as? String,
                            let title = data[K.FStore.Field.title] as? String,
                            let date = data[K.FStore.Field.date] as? Timestamp,
                            let startAt = data[K.FStore.Field.start] as? Timestamp,
                            let end = data[K.FStore.Field.end] as? Timestamp,
                            let descritpion = data[K.FStore.Field.description] as? String {
                            let task = Task(id: id, title: title, dateBegin: date.dateValue(), startAt: startAt.dateValue(), endTo: end.dateValue(), description: descritpion)
                            
                            userTasks.insert(task)
                        }
                    }
                } else {
                    print("Doc is nil")
                }
                completion()
            })
    }
    
    static func removeUserTaskWithId(_ id: String, completion:@escaping(() -> ())) {
        db.collection(K.FStore.Collection.tasks)
            .document(userId!)
            .collection(K.FStore.Collection.userTasks)
            .getDocuments { querySnaphost, error in
                if let e = error {
                    print("Can't delete document cause: \(e)")
                } else {
                    for document in querySnaphost!.documents {
                        if document.data()[K.FStore.Field.id] as? String == id {
                            document.reference.delete()
                            for task in userTasks {
                                if task.id == id {
                                    userTasks.remove(task)
                                }
                            }
                            completion()
                        }
                    }
                }
            }
    }
    
    private static func getUserInfo(completion:@escaping(() -> ())) {
        db.collection(K.FStore.Collection.userInfo)
            .document(userId!)
            .getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                if let username = data[K.FStore.Field.name] as? String,
                   let email = data[K.FStore.Field.email] as? String {
                    userInfo = UserInfo(username: username, email: email)
                }
                completion()
            } else {
                print("Document does not exist")
                completion()
            }
        }
    }
    
    
}
