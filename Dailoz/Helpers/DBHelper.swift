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
    
    static let userUid = Auth.auth().currentUser?.uid
    
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
    
    static func saveDataToSubcollection(collection: String, documentName: String, subCollection: String, data:[String: Any]) {
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
    
    static func getUserTasks(completion:@escaping(([Task]?) -> ())) {
        var tasks: [Task] = []
        
        db.collection(K.FStore.Collection.tasks)
            .document(userUid!)
            .collection(K.FStore.Collection.userTasks)
            .addSnapshotListener({ querySnapshot, error in
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let title = data[K.FStore.Field.title] as? String,
                           let date = data[K.FStore.Field.date] as? Timestamp,
                           let startAt = data[K.FStore.Field.start] as? Timestamp,
                           let end = data[K.FStore.Field.end] as? Timestamp,
                           let descritpion = data[K.FStore.Field.description] as? String {
                            let task = Task(title: title, dateBegin: date.dateValue(), startAt: startAt.dateValue(), endTo: end.dateValue(), description: descritpion)
                            
                            tasks.append(task)
                        }
                    }
                    completion(tasks)
                } else {
                    print("Doc is nil")
                }
            })
    }
    
    
    static func getInfo(completion:@escaping(([String: Any]?) -> ())) {
        let docRef = db.collection(K.FStore.Collection.userInfo).document(userUid!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let documentData = document.data()!
                print("Document data fetched: \(documentData)")
                
                completion(documentData)
            } else {
                print("Document does not exist")
                
                completion(nil)
            }
        }
    }
    
    
}
