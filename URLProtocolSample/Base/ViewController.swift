//
//  ViewController.swift
//  URLProtocolSample
//
//  Created by Kosuke Matsuda on 2017/10/22.
//  Copyright © 2017年 matsuda. All rights reserved.
//

import UIKit

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
        let urlRequest = URLRequest(url: URL(string: "https://api.github.com/users/octcat")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
//            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
//            print(json)
            let string = String(data: data, encoding: .utf8)
            DispatchQueue.main.async { [unowned self] in
                self.textView.text = string
            }
        }
        task.resume()
    }

    func stub() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [CustomURLProtocol.self]
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: URL(string: "https://api.test.com/users/foo")!)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            let string = String(data: data, encoding: .utf8)
            DispatchQueue.main.async { [unowned self] in
                self.textView.text = string
            }
        }
        task.resume()
    }

    /*
    func request() {
        #if DEBUG
            let urlRequest = URLRequest(url: URL(string: "https://api.test.com/users/foo")!)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                // 結果処理
            }
            task.resume()
        #else
            let path = Bundle.main.path(forResource: "user", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            DispatchQueue.global().async {
                // 結果処理
            }
        #endif
    }
     */
}
