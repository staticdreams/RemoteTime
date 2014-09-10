//
//  ViewController.swift
//  RemoteTime
//
//  Created by Peter on 10/09/14.
//  Copyright (c) 2014 Peter Tikhomirov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBAction func upAction(sender: AnyObject) {
		self.submitRequest(method: "up", parameters: []) {
			responseObject, error in
		}
	}
	
	@IBAction func downAction(sender: AnyObject) {
		self.submitRequest(method: "down", parameters: []) {
			responseObject, error in
		}
	}
	
	@IBAction func leftAction(sender: AnyObject) {
		self.submitRequest(method: "left", parameters: []) {
			responseObject, error in
		}
	}

	@IBAction func rightAction(sender: AnyObject) {
		self.submitRequest(method: "right", parameters: []) {
			responseObject, error in
		}
	}
	
	@IBAction func backAction(sender: AnyObject) {
		self.submitRequest(method: "back", parameters: []) {
			responseObject, error in
		}
	}
	
	@IBAction func playAction(sender: AnyObject) {
		self.submitRequest(method: "toggleplaying", parameters: []) {
			responseObject, error in
		}
	}
	
	@IBAction func okAction(sender: AnyObject) {
		self.submitRequest(method: "enter", parameters: []) {
			responseObject, error in
			//			if error != nil {
			//				println("error = \(error)")
			//				println("responseObject = \(responseObject)")
			//				return
			//			}
			//			println("responseObject = \(responseObject)")
		}
	}
	
	func submitRequest(#method:String, parameters: AnyObject, completion: (responseObject: AnyObject!, error: NSError!) -> (Void)) -> NSURLSessionTask? {
		
		let session = NSURLSession.sharedSession()
		let url = NSURL(string: "http://192.168.1.36:8012")
		let request = NSMutableURLRequest(URL: url)
		
		var str = "popcorn:popcorn"
		let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
		let base64Encoded = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.fromRaw(0)!)
		
		var authValue = NSString(format: "Basic %@", base64Encoded)
		
		request.HTTPMethod = "POST"
		request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
		request.setValue(authValue, forHTTPHeaderField: "Authorization")
		
		let requestDictionary = [
			"jsonrpc" : "2.0",
			"method"  : method,
			"params"  : parameters
		]
		
		var error: NSError?
		let requestBody = NSJSONSerialization.dataWithJSONObject(requestDictionary, options: nil, error: &error)
		if requestBody == nil {
			completion(responseObject: nil, error: error)
			return nil
		}
		
		request.HTTPBody = requestBody
		
		let task = session.dataTaskWithRequest(request) {
			data, response, error in
			if error != nil {
				completion(responseObject: data, error: error)
				return
			}
			var parseError: NSError?
			let responseObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError) as? NSDictionary
			
			if responseObject == nil {
				let responseString = NSString(data: data, encoding: NSUTF8StringEncoding) as String
				completion(responseObject: responseString, error: parseError)
				return
			}
			completion(responseObject: responseObject, error: nil)
		}
		task.resume()
		return task
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}


}

