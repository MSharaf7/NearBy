//
//  UserInfo.swift
//  NearBy
//
//  Created by Marwan Sharaf on 9/11/22.
//

import Foundation

struct UserInfo {
    let uid, email, profileImageUrl: String
    
    init(data: [String:Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
