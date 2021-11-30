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
    
    static func saveDataToDB(collection: String, documentName: String, data:[String: Any]) {
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
    
    
    static func loadInfo(completion:@escaping(([String: Any]?) -> ())) {
        let docRef = db.collection(K.FStore.userInfoCollection).document(userUid!)

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
