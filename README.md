# SNNetworkClient
The lightweight network client for sending GET, POST request with decodabble object response.

# Installation
### CocoaPods ### 
Add SNNetworkClient to your Podfile:
````rb
pod 'SNNetworkClient', '1.0.2'
````
Then run `pod install`.
# Dependency
SNNetworkClient depend on below framework
- RxSwift
- Alamofire

# Usage
Assume that, we have 2 apis for fetching post and creating post.
- GET: https://jsonplaceholder.typicode.com/posts
- POST: https://jsonplaceholder.typicode.com/posts with json object
````json
{
    "title": "",
    "id": 1,
    "body": "",
    "userId": 1
}
````
 With SNNetworkClient we need follow below steps.

1. Define struct or enum implement ``SNTarget``
````swift
enum PostTarget {
    case fetchPosts
    case createPost(title: String, body: String, userId: Int)
}
````
````swift
extension PostTarget: SNTargetType {
    var path: String {
        switch self {
        case .fetchPosts:
            return "/posts"
        case .createPost:
            return "/posts"
        }
    }
    
    var method: SNHttpMethod {
        switch self {
        case .fetchPosts:
            return .get
        case .createPost:
            return .post
        }
    }
    
    var params: [String : Any]? {
        switch self {
        case .fetchPosts:
            return nil
        case .createPost(let title, let body, let userId):
            return [
                "title": title,
                "body": body,
                "userId": userId
            ]
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var encoding: SNEncodingMethod {
        return .jsonEncoding
    }
}
````
2. Create Response model implemnt `Decodable`
````swift
struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
````
3. Declare SNNetworkClient object
````swift
        let baseUrl = URL(string: "https://jsonplaceholder.typicode.com")!
        let nw: SNNetworkClient = SNNetworkClientImpl(baseUrl: baseUrl)
````
4. Finally, perform request
- fetchPosts
````swift
        nw.request(target: PostTarget.fetchPosts, type: Posts.self)
            .subscribe { toDo in
                print(toDo)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
````
- createPost
````swift
        nw.request(target: PostTarget.createPost(
            title: "title of post",
            body: "body of post",
            userId: 123), type: Post.self)
        .subscribe { toDo in
            print(toDo)
        } onError: { error in
            print(error)
        }
        .disposed(by: disposeBag)v
````
