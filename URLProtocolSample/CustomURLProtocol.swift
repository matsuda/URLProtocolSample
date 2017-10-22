//
//  CustomURLProtocol.swift
//  URLProtocolSample
//
//  Created by Kosuke Matsuda on 2017/10/22.
//  Copyright © 2017年 matsuda. All rights reserved.
//

import Foundation

class CustomURLProtocol: URLProtocol {
    let cannedHeaders = ["Content-Type" : "application/json;"]

    override class func canInit(with request: URLRequest) -> Bool {
        print(#function)
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        print(#function)
        return request
    }

    override func startLoading() {
        print(#function)
        guard
            let path = Bundle.main.path(forResource: "user", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                let client = self.client
                let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: "HTTP/1.1", headerFields: cannedHeaders)
                client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
                let error = NSError(domain: "CustomURLProtocolError", code: 10001, userInfo: nil)
                client?.urlProtocol(self, didFailWithError: error)
                return
        }

        let client = self.client
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: cannedHeaders)
        client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        print(#function)
    }
}
