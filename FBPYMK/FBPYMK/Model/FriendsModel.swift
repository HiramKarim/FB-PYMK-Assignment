//
//  FriendsModel.swift
//  FBPYMK
//
//  Created by Hiram Castro on 25/04/21.
//

import Foundation

struct FriendsModel:Decodable {
    let id:Int
    let name:String
    let friends:[Int]
}
