//
//  DBHelper.swift
//  Dailoz
//
//  Created by MAKOVEY Vladislav on 30.11.2021.
//

import FirebaseAuth
import FirebaseFirestore

struct DBHelper {
    
    static let database = Firestore.firestore()
    
    static var userTasks = Set<Task>()
    
    static var userInfo: UserInfo?
    
    static var userId: String?
    
    static func saveDataTo(collection: String, data: [String: Any]) {
        database.collection(collection)
            .document(userId!)
            .setData(data) { error in
                if let error = error {
                    print("There was an issue saving data to Firestore \(error)")
                } else {
                    print("Successfully saving data to collection: \(collection)")
                }
            }
    }
    
    static func getOnlyTaskOfDay(_ date: Date) -> [Task]? {
        if !userTasks.isEmpty && !filterTaskByDay(date).isEmpty {
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
        database.collection(collection)
            .document(userId!)
            .collection(subCollection)
            .document()
            .setData(data) { error in
                if let error = error {
                    print("There was an issue saving data to Firestore \(error)")
                } else {
                    print("Successfully saving data to collection: \(collection) and subcollection \(subCollection)")
                }
            }
    }
    
    static func updateUserTask(updatableTask: Task, data: [String: Any], completion:@escaping(() -> Void)) {
        database.collection(K.FStore.Collection.tasks)
            .document(userId!)
            .collection(K.FStore.Collection.userTasks)
            .getDocuments { querySnaphost, error in
                if let error = error {
                    print("Can't update task cause: \(error)")
                } else {
                    for document in querySnaphost!.documents {
                        if document.data()[K.FStore.Field.id] as? String == updatableTask.id {
                            document.reference.updateData(data)
                            for task in userTasks where task.id == updatableTask.id {
                                userTasks.remove(task)
                                userTasks.insert(updatableTask)
                            }
                            completion()
                        }
                    }
                }
            }
    }
    
    static func updateUserInfo(data: [String: Any], completion:@escaping(() -> Void)) {
        let user = Auth.auth().currentUser!
        
        database.collection(K.FStore.Collection.userInfo)
            .document(userId!)
            .updateData(data) { error in
                if let error = error {
                    print("Can't update users data cause: \(error)")
                } else {
                    if data.keys.contains(K.FStore.Field.name) {
                        if let newName = data[K.FStore.Field.name] as? String {
                            userInfo?.username = newName
                        }
                    } else {
                        if let newEmail = data[K.FStore.Field.email] as? String {
                            userInfo?.email = newEmail
                            user.updateEmail(to: newEmail) { _ in
                                print("Can't update email in firebase")
                           }
                        }

                    }
                }
                completion()
            }
    }
    
    static func prepareData(completion:@escaping(() -> Void)) {
        userId = Auth.auth().currentUser?.uid
        loadUserInfo {
            fetchUserTasks {
                completion()
            }
        }
    }
    
    static func reloadUserTasks(completion:@escaping(() -> Void)) {
        database.collection(K.FStore.Collection.tasks)
            .document(userId!)
            .collection(K.FStore.Collection.userTasks)
            .addSnapshotListener({ querySnapshot, _ in
                if let snapshotDocument = querySnapshot?.documents {
                    fillCollectionWithData(snapshotDocument: snapshotDocument)
                } else {
                    print("No documents appeared")
                }
                completion()
            })
    }
    
    private static func fetchUserTasks(completion:@escaping(() -> Void)) {
        database.collection(K.FStore.Collection.tasks)
            .document(userId!)
            .collection(K.FStore.Collection.userTasks)
            .getDocuments { querySnapshot, _ in
                if let snapshotDocument = querySnapshot?.documents {
                    fillCollectionWithData(snapshotDocument: snapshotDocument)
                }
                completion()
            }
    }
    
    private static func fillCollectionWithData(snapshotDocument: [QueryDocumentSnapshot]) {
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
    
    static func removeUserTaskWithId(_ id: String, completion:@escaping(() -> Void)) {
        database.collection(K.FStore.Collection.tasks)
            .document(userId!)
            .collection(K.FStore.Collection.userTasks)
            .getDocuments { querySnaphost, error in
                if let error = error {
                    print("Can't delete document cause: \(error)")
                } else {
                    for document in querySnaphost!.documents {
                        if document.data()[K.FStore.Field.id] as? String == id {
                            document.reference.delete()
                            for task in userTasks where task.id == id {
                                userTasks.remove(task)
                            }
                            completion()
                        }
                    }
                }
            }
    }
    
    private static func loadUserInfo(completion: @escaping(() -> Void)) {
        database.collection(K.FStore.Collection.userInfo)
            .document(userId!)
            .getDocument { (document, _) in
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
    
    static func getTasksByType(_ type: String) -> Set<Task>? {
        if type == "all" {
            return !userTasks.isEmpty ? userTasks : nil
        }
        let filteredTask = userTasks.filter { $0.type == type }
        return !filteredTask.isEmpty ? filteredTask : nil
    }
    
    static func getTasksByDonable(_ type: String) -> Set<Task>? { // swiftlint:disable:this cyclomatic_complexity
        var filteredTask: Set<Task>? = Set<Task>()
        let today = Date()
        
        switch type {
        case "active":
            for task in userTasks {
                if task.isDone { continue }
                
                if task.dateBegin.get(.year) > today.get(.year) {
                    filteredTask?.insert(task)
                } else if task.dateBegin.get(.year) == today.get(.year) {
                    if task.dateBegin.get(.month) > today.get(.month) {
                        filteredTask?.insert(task)
                    } else if task.dateBegin.get(.month) == today.get(.month) {
                        if task.dateBegin.get(.day) > today.get(.day) {
                            filteredTask?.insert(task)
                        } else if task.dateBegin.get(.day) == today.get(.day) {
                            if task.dateBegin.get(.hour) > today.get(.hour) {
                                filteredTask?.insert(task)
                            } else if task.dateBegin.get(.hour) == today.get(.hour) {
                                if task.startAt.get(.minute) >= today.get(.minute) {
                                    filteredTask?.insert(task)
                                }
                            }
                        }
                    }
                }
            }
            
        case "expired":
            for task in userTasks {
                if task.isDone { continue }
                
                if task.dateBegin.get(.year) < today.get(.year) {
                    filteredTask?.insert(task)
                } else if task.dateBegin.get(.year) == today.get(.year) {
                    if task.dateBegin.get(.month) < today.get(.month) {
                        filteredTask?.insert(task)
                    } else if task.dateBegin.get(.month) == today.get(.month) {
                        if task.dateBegin.get(.day) < today.get(.day) {
                            filteredTask?.insert(task)
                        } else if task.dateBegin.get(.day) == today.get(.day) {
                            if task.dateBegin.get(.hour) < today.get(.hour) {
                                filteredTask?.insert(task)
                            } else if task.dateBegin.get(.hour) == today.get(.hour) {
                                if task.startAt.get(.minute) < today.get(.minute) {
                                    filteredTask?.insert(task)
                                }
                            }
                        }
                    }
                }
            }
        case "done":
            filteredTask = userTasks.filter { $0.isDone == true }
        default:
            filteredTask = nil
        }
        
        if let filteredTask = filteredTask {
            if !filteredTask.isEmpty { return filteredTask } else { return nil }
        } else { return nil }
    }
    
    static func deleteAccountAndTasks(completion:@escaping(() -> Void)) {
        database.collection(K.FStore.Collection.userInfo)
            .document(userId!)
            .delete { error in
                if let error = error {
                    print("Can't delete account cause \(error)")
                } else {
                    database.collection(K.FStore.Collection.tasks)
                        .document(userId!)
                        .collection(K.FStore.Collection.userTasks)
                        .getDocuments { querySnapshot, error in
                            if let error = error {
                                print("Can't delete all documents cause: \(error)")
                            }
                            for doc in querySnapshot!.documents {
                                doc.reference.delete()
                                DBHelper.userTasks.removeAll()
                            }
                        }
                    
                    Auth.auth().currentUser?.delete(completion: { error in
                        do {
                            try Auth.auth().signOut()
                        } catch {
                            print(error)
                        }

                        if let error = error {
                            print("Can't delete user from firebase cause \(error)")
                        }
                        
                        completion()
                    })
                }
            }
    }
}
