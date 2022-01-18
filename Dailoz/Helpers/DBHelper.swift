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
    
    static var userId: String? = nil
    
    static func saveDataTo(collection: String, data:[String: Any]) {
        db.collection(collection)
            .document(userId!)
            .setData(data) { error in
                if let e = error {
                    print("There was an issue saving data to Firestore \(e)")
                } else {
                    print("Successfully saving data to collection: \(collection)")
                }
            }
    }
    
    static func getOnlyTaskOfDay(_ date: Date) -> [Task]? {
        if userTasks.count != 0 && filterTaskByDay(date).count > 0 {
            return filterTaskByDay(date)
        } else {
            return nil
        }
    }
    
    private static func filterTaskByDay(_ date: Date) -> [Task] {
        return userTasks.filter { task in
            let component = DateHelper.getMonthAndDay(date: task.dateBegin)
            let today = DateHelper.getMonthAndDay(date: date)
            
            let result = component.month == today.month! && component.day! == today.day
            return result
        }
    }
    
    static func saveDataToSubcollection(collection: String, subCollection: String, data: [String: Any]) {
        db.collection(collection)
            .document(userId!)
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
    
    static func updateUserTask(updatableTask: Task, data: [String: Any] ,completion:@escaping(() -> ())) {
        db.collection(K.FStore.Collection.tasks)
            .document(userId!)
            .collection(K.FStore.Collection.userTasks)
            .getDocuments { querySnaphost, error in
                if let e = error {
                    print("Can't update task cause: \(e)")
                } else {
                    for document in querySnaphost!.documents {
                        if document.data()[K.FStore.Field.id] as? String == updatableTask.id {
                            document.reference.updateData(data)
                            for task in userTasks {
                                if task.id == updatableTask.id {
                                    userTasks.remove(task)
                                    userTasks.insert(updatableTask)
                                }
                            }
                            completion()
                        }
                    }
                }
            }
    }
    
    static func updateUserInfo(data: [String: Any] ,completion:@escaping(() -> ())) {
        let user = Auth.auth().currentUser!
        
        db.collection(K.FStore.Collection.userInfo)
            .document(userId!)
            .updateData(data) { error in
                if let e = error {
                    print("Can't update users data cause: \(e)")
                } else {
                    if data.keys.contains(K.FStore.Field.name) {
                        let newName = data[K.FStore.Field.name] as! String
                        userInfo?.username = newName
                    } else {
                        let newEmail = data[K.FStore.Field.email] as! String
                        userInfo?.email = newEmail
                        user.updateEmail(to: newEmail) { error in
                            print("Can't update email in firebase")
                        }
                    }
                }
                completion()
            }
    }
    
    static func prepareData(completion:@escaping(() -> ())) {
        userId = Auth.auth().currentUser?.uid
        loadUserInfo {
            fetchUserTasks {
                completion()
            }
        }
    }
    
    static func reloadUserTasks(completion:@escaping(() -> ())) {
        db.collection(K.FStore.Collection.tasks)
            .document(userId!)
            .collection(K.FStore.Collection.userTasks)
            .addSnapshotListener({ querySnapshot, error in
                if let snapshotDocument = querySnapshot?.documents {
                    fillCollectionWithData(snapshotDocument: snapshotDocument)
                } else {
                    print("No documents appeared")
                }
                completion()
            })
    }
    
    // if hotswap works correctly, remove it
    static func fetchUserTasks(completion:@escaping(() -> ())) {
        db.collection(K.FStore.Collection.tasks)
            .document(userId!)
            .collection(K.FStore.Collection.userTasks)
            .getDocuments { querySnapshot, error in
                if let snapshotDocument = querySnapshot?.documents {
                    fillCollectionWithData(snapshotDocument: snapshotDocument)
                }
                completion()
            }
    }
    
    static func fillCollectionWithData(snapshotDocument: [QueryDocumentSnapshot]) {
        for doc in snapshotDocument {
            let data = doc.data()
            
            if  let id = data[K.FStore.Field.id] as? String,
                let title = data[K.FStore.Field.title] as? String,
                let date = data[K.FStore.Field.date] as? Timestamp,
                let startAt = data[K.FStore.Field.start] as? Timestamp,
                let end = data[K.FStore.Field.end] as? Timestamp,
                let type = data[K.FStore.Field.type] as? String,
                let descritpion = data[K.FStore.Field.description] as? String,
                let isDone = data[K.FStore.Field.isDone] as? Bool,
                let isNeededRemind = data[K.FStore.Field.isNeededRemind] as? Bool {
                let task = Task(id: id,
                                title: title,
                                dateBegin: date.dateValue(),
                                startAt: startAt.dateValue(),
                                until: end.dateValue(),
                                type: type,
                                description: descritpion,
                                isDone: isDone,
                                isNeededRemind: isNeededRemind)
                
                userTasks.insert(task)
            }
        }
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
    
    private static func loadUserInfo(completion: @escaping(() -> ())) {
        db.collection(K.FStore.Collection.userInfo)
            .document(userId!)
            .getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()!
                    if let username = data[K.FStore.Field.name] as? String,
                       let email = data[K.FStore.Field.email] as? String {
                        userInfo = UserInfo(username: username, email: email)
                    }
                } else {
                    print("Document does not exist")
                }
                completion()
            }
    }
    
    static func getTasksByType(_ type: String) -> [Task]? {
        if type == "all" {
            return userTasks.count > 0 ? Array(userTasks) : nil
        }
        let filteredTask = userTasks.filter { $0.type == type }
        return filteredTask.count > 0 ? Array(filteredTask) : nil
    }
    
    static func getTasksByDonable(_ type: String) -> [Task]? {
        var filteredTask: [Task]? = [Task]()
        let today = Date()
        
        
        switch type {
        case "active":
            for task in userTasks {
                if task.isDone { break }
                if task.dateBegin.get(.year) > today.get(.year) {
                    filteredTask?.append(task)
                } else if task.dateBegin.get(.month) > today.get(.month) {
                    filteredTask?.append(task)
                } else if task.dateBegin.get(.day) > today.get(.day) {
                    filteredTask?.append(task)
                } else if task.dateBegin.get(.day) == today.get(.day) && task.dateBegin.get(.hour) > today.get(.hour) {
                    filteredTask?.append(task)
                } else if task.dateBegin.get(.day) == today.get(.day) && task.startAt.get(.hour) == today.get(.hour) && task.startAt.get(.minute) >= today.get(.minute) {
                    filteredTask?.append(task)
                }
            }
        case "expired":
            for task in userTasks {
                if task.isDone { break }
                if task.dateBegin.get(.year) < today.get(.year) {
                    filteredTask?.append(task)
                } else if task.dateBegin.get(.month) < today.get(.month) {
                    filteredTask?.append(task)
                } else if task.dateBegin.get(.day) < today.get(.day) {
                    filteredTask?.append(task)
                } else if task.dateBegin.get(.day) == today.get(.day) && task.dateBegin.get(.hour) < today.get(.hour) {
                    filteredTask?.append(task)
                } else if task.dateBegin.get(.day) == today.get(.day) && task.startAt.get(.hour) == today.get(.hour) && task.startAt.get(.minute) < today.get(.minute) {
                    filteredTask?.append(task)
                }
            }
        case "done":
            filteredTask = userTasks.filter { $0.isDone == true }
        default:
            filteredTask = nil
        }
        
        if let filteredTask = filteredTask {
            if filteredTask.count > 0 { return filteredTask }
            else { return nil }
        } else { return nil }
    }
    
    static func deleteAccountAndTasks(completion:@escaping(() -> ())) {
        db.collection(K.FStore.Collection.userInfo)
            .document(userId!)
            .delete { error in
                if let e = error {
                    print("Can't delete account cause \(e)")
                } else {
                    db.collection(K.FStore.Collection.tasks)
                        .document(userId!)
                        .collection(K.FStore.Collection.userTasks)
                        .getDocuments { querySnapshot, error in
                            if let e = error {
                                print("Can't delete all documents cause: \(e)")
                            }
                            for doc in querySnapshot!.documents {
                                doc.reference.delete()
                                DBHelper.userTasks.removeAll()
                            }
                        }
                    
                    Auth.auth().currentUser?.delete(completion: { error in
                        if let e = error {
                            print("Can't delete user from firebase cause \(e)")
                        }
                    })
                }
                completion()
            }
    }
}
