//
//  MainVM.swift
//  FBPYMK
//
//  Created by Hiram Castro on 25/04/21.
//

import Foundation

class MainVM {
    
    var friendsSuggestions:[FriendsModel] = []
    var socialDistance = [Int:[Int]]()
    var mutualFriends = [Int:[Int]]()
    private var currentUser:FriendsModel!
    
    init(jsonFile:String) {
        getData(jsonFile: jsonFile)
    }
    
    private func getData(jsonFile:String) {
        guard let jsonData = readLocalFile(forName: jsonFile),
              let friendsArray = parse(jsonData: jsonData) else { return }
        
        self.friendsSuggestions = friendsArray
        
        currentUser = friendsArray.first
        
        friendsSuggestions.removeFirst()
        
        calculateSocialDistance(friendsSuggestions: friendsSuggestions)
        calculateMutualFriends(friendsSuggestions: friendsSuggestions)
    }
    
    private func calculateSocialDistance(friendsSuggestions:[FriendsModel]) {
        
        for user in friendsSuggestions {
            
            if currentUser.friends.contains(user.id) {
                socialDistance[user.id] = [1]
            }
            
        }
        
    }
    
    
    /*
     - Description: This algorithm search for the friends ID of the 'Facebook Candidate' into the array of friends ID of the suggested friends.
     If the friend ID is found, it will count as a mutual friend.
     
     - Runtime complexity: O(n^2)
     */
    private func calculateMutualFriends(friendsSuggestions:[FriendsModel]) {
        for user in friendsSuggestions {
            for friendID in currentUser?.friends ?? [] {
                if user.friends.contains(friendID) {
                    if var currentValues = mutualFriends[user.id] {
                        currentValues.append(friendID)
                        mutualFriends.updateValue(currentValues, forKey: user.id)
                    } else {
                        mutualFriends[user.id] = [friendID]
                    }
                }
            }
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) -> [FriendsModel]? {
        do {
            let decodedData = try JSONDecoder().decode([FriendsModel].self,
                                                       from: jsonData)
            return decodedData
        } catch {
            print("decode error")
            return nil
        }
    }
    
}
