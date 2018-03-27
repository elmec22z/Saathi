
import UIKit

class Post: NSObject {

    
    var author: String!
    var likes: Int!
    var pathToImage: String!
    var userID: String!
    var postID: String!
    var titles: String!
    var descriptions: String!
    var locations: String!
    var languages: String!
    var peopleWhoLike: [String] = [String]()
}
