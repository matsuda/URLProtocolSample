//
//  ViewController.swift
//  URLProtocolSample
//
//  Created by Kosuke Matsuda on 2017/10/22.
//  Copyright © 2017年 matsuda. All rights reserved.
//

import UIKit
import APIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var count = 0
    @IBAction func tapButton(_ sender: Any) {
        if count % 2 == 0 {
            stub()
        } else {
            request()
        }
        count += 1
    }
}

extension ViewController {
    func request() {
        let request = UserRequest()
        APIKit.Session.send(request) { (result) in
            switch result {
            case .success(let response):
                print("Response :", response)
                self.textView.text = "\(response)"
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
    func stub() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [CustomURLProtocol.self]
        let adapter = URLSessionAdapter(configuration: config)
        let sesson = APIKit.Session(adapter: adapter)

        let request = UserStubRequest()
        sesson.send(request) { (result) in
            switch result {
            case .success(let response):
                print("Response :", response)
                self.textView.text = "\(response)"
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
}

struct User: Codable {
    let login: String
    let id: Int
    let url: String
}

struct UserRequest: Request {
    typealias Response = User
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    var path: String {
        return "/users/octcat"
    }
}

struct UserStubRequest: Request {
    typealias Response = User
    var baseURL: URL {
        return URL(string: "https://api.test.com")!
    }
    var path: String {
        return "/users/foo"
    }
}

extension APIKit.Request where Response: Decodable {
    var method: HTTPMethod {
        return .get
    }
    var dataParser: DataParser {
        return JSONDataParser()
    }
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

class JSONDataParser: DataParser {
    var contentType: String? {
        return "application/json"
    }
    func parse(data: Data) throws -> Any {
        return data
    }
}

//let Session: APIKit.Session = {
//    let config = URLSessionConfiguration.default
//    config.protocolClasses = [CustomURLProtocol.self]
//    let adapter = URLSessionAdapter(configuration: config)
//    return APIKit.Session(adapter: adapter)
//}()

