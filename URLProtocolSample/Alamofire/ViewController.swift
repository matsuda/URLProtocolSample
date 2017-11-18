//
//  ViewController.swift
//  URLProtocolSample
//
//  Created by Kosuke Matsuda on 2017/10/22.
//  Copyright © 2017年 matsuda. All rights reserved.
//

import UIKit
import Alamofire

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
        Alamofire.request("https://api.github.com/users/octcat").responseString { response in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value ?? "")")
            DispatchQueue.main.async { [unowned self] in
                self.textView.text = response.value
            }
        }
    }
    func stub() {
        Manager.request("https://api.test.com/users/foo").responseString { response in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value ?? "")")
            print("Error: \(response.error)")
            DispatchQueue.main.async { [unowned self] in
                self.textView.text = response.value
            }
        }
    }
}

let Manager: SessionManager = {
    let config = URLSessionConfiguration.default
    config.protocolClasses = [CustomURLProtocol.self]
    return SessionManager(configuration: config)
}()
