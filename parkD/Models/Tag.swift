//
//  Comment.swift
//  parkD
//
//  Created by Adam on 11/9/16.
//  Copyright © 2016 ece590. All rights reserved.
//

import Foundation
import Firebase

struct Tag {
    
    // MARK: Constants
    let key: String
    let name: String
    let ref: FIRDatabaseReference?
    let tagRef = FIRDatabase.database().reference(withPath: "tags")
    let accurateAgreeScoreRef = "accurateAgreeScore"
    let accurateDisagreeScoreRef = "accurateDisagreeScore"
    let notAccurateAgreeScoreRef = "notAccurateAgreeScore"
    let notAccurateDisagreeScoreRef = "notAccurateDisagreeScore"
    let accurateVotersRef = "accurateVoters"
    let accurateVotersFBRef = FIRDatabase.database().reference(withPath: "accurateVoters")
    let notAccurateVotersFBRef = FIRDatabase.database().reference(withPath: "notAccurateVoters")

    // MARK: Variables
    var delegate: TagVoteChanged?
    var accurateAgreeScore: Int
    var accurateDisagreeScore: Int
    var notAccurateAgreeScore: Int
    var notAccurateDisagreeScore: Int
    var zoneName: String
    var user : User?
    var accurateVoters: [String: String]
    var notAccurateVoters: [String: String]
    
    init(name: String, accurateAgreeScore: Int, accurateDisagreeScore: Int, notAccurateAgreeScore: Int, notAccurateDisagreeScore: Int, zoneName: String, accurateVoters: [String: String], notAccurateVoters: [String: String]){
        // Initializes comment through parameters.
        self.name = name
        self.accurateAgreeScore = accurateAgreeScore
        self.accurateDisagreeScore = accurateDisagreeScore
        self.notAccurateAgreeScore = notAccurateAgreeScore
        self.notAccurateDisagreeScore = notAccurateDisagreeScore
        self.key = ""
        self.zoneName = zoneName
        self.accurateVoters = accurateVoters
        self.notAccurateVoters = notAccurateVoters
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        // Initializes comment through Firebase data.
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        zoneName = snapshotValue["zoneName"] as! String
        accurateAgreeScore = snapshotValue["accurateAgreeScore"] as! Int
        accurateDisagreeScore = snapshotValue["accurateDisagreeScore"] as! Int
        notAccurateAgreeScore = snapshotValue["notAccurateAgreeScore"] as! Int
        notAccurateDisagreeScore = snapshotValue["notAccurateDisagreeScore"] as! Int
        accurateVoters = (snapshotValue["accurateVoters"] as! NSDictionary) as! [String : String]
        notAccurateVoters = (snapshotValue["notAccurateVoters"] as! NSDictionary) as! [String: String]
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            // Creates data to be stored into Firebase database.
            "name": name,
            "accurateAgreeScore": accurateAgreeScore,
            "accurateDisagreeScore": accurateDisagreeScore,
            "notAccurateAgreeScore": notAccurateAgreeScore,
            "notAccurateDisagreeScore": notAccurateDisagreeScore,
            "zoneName": zoneName
        ]
    }
    
    func clickAccurateUp() {
        // Increase accurate agree score by 1
        let localTagRef = tagRef.child(zoneName).child(name)
        let accurateTagRef = localTagRef.child(self.accurateAgreeScoreRef)
        localTagRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String: AnyObject]
            let count = value?[self.accurateAgreeScoreRef] as! Int
            accurateTagRef.setValue(count + 1)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard user != nil else { return }
            let userUID = user?.uid
            self.accurateVotersFBRef.child(self.name).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String: AnyObject]
                let accurateVoters = value?[self.zoneName] as! NSDictionary
                if(accurateVoters[userUID!] != nil) {
                    // If userUID lookup is not nil, user has already voted
                    localTagRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Reverse score update due to existing vote
                        let value = snapshot.value as? [String: AnyObject]
                        let count = value?[self.accurateAgreeScoreRef] as! Int
                        accurateTagRef.setValue(count - 1)
                        return
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                self.accurateVotersFBRef.child(self.name).child(self.zoneName).child(userUID!).setValue(userUID)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func clickNotAccurateUp() {
        // Increase not accurate agree score by 1
        let localTagRef = tagRef.child(zoneName).child(name)
        let notAccurateTagRef = localTagRef.child(self.notAccurateAgreeScoreRef)
        localTagRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String: AnyObject]
            let count = value?[self.notAccurateAgreeScoreRef] as! Int
            notAccurateTagRef.setValue(count + 1)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard user != nil else { return }
            let userUID = user?.uid
            self.notAccurateVotersFBRef.child(self.name).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String: AnyObject]
                let notAccurateVoters = value?[self.zoneName] as! NSDictionary
                if(notAccurateVoters[userUID!] != nil) {
                    // If userUID lookup is not nil, user has already voted
                    localTagRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Reverse score update due to existing vote
                        let value = snapshot.value as? [String: AnyObject]
                        let count = value?[self.notAccurateAgreeScoreRef] as! Int
                        notAccurateTagRef.setValue(count - 1)
                        return
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                self.notAccurateVotersFBRef.child(self.name).child(self.zoneName).child(userUID!).setValue(userUID)
                self.delegate?.changedState()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func clickAccurateDown() {
        // Increase accurate disagree score by 1
        let localTagRef = tagRef.child(zoneName).child(name)
        let accurateTagRef = localTagRef.child(self.accurateDisagreeScoreRef)
        localTagRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String: AnyObject]
            let count = value?[self.accurateDisagreeScoreRef] as! Int
            accurateTagRef.setValue(count + 1)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard user != nil else { return }
            let userUID = user?.uid
            self.accurateVotersFBRef.child(self.name).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String: AnyObject]
                let accurateVoters = value?[self.zoneName] as! NSDictionary
                if(accurateVoters[userUID!] != nil) {
                    // If userUID lookup is not nil, user has already voted
                    localTagRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Reverse score update due to existing vote
                        let value = snapshot.value as? [String: AnyObject]
                        let count = value?[self.accurateDisagreeScoreRef] as! Int
                        accurateTagRef.setValue(count - 1)
                        return
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                self.accurateVotersFBRef.child(self.name).child(self.zoneName).child(userUID!).setValue(userUID)
                self.delegate?.changedState()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func clickNotAccurateDown() {
        // Increase not accurate disagree score by 1
        let localTagRef = tagRef.child(zoneName).child(name)
        let notAccurateTagRef = localTagRef.child(self.notAccurateDisagreeScoreRef)
        localTagRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String: AnyObject]
            let count = value?[self.notAccurateDisagreeScoreRef] as! Int
            notAccurateTagRef.setValue(count + 1)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Authenticate user via Firebase.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard user != nil else { return }
            let userUID = user?.uid
            self.notAccurateVotersFBRef.child(self.name).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String: AnyObject]
                let notAccurateVoters = value?[self.zoneName] as! NSDictionary
                if(notAccurateVoters[userUID!] != nil) {
                    // If userUID lookup is not nil, user has already voted
                    localTagRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Reverse score update due to existing vote
                        let value = snapshot.value as? [String: AnyObject]
                        let count = value?[self.notAccurateDisagreeScoreRef] as! Int
                        notAccurateTagRef.setValue(count - 1)
                        return
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                self.notAccurateVotersFBRef.child(self.name).child(self.zoneName).child(userUID!).setValue(userUID)
                self.delegate?.changedState()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
}
