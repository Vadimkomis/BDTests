//
//  BDTestsMain.swift
//  BDTest
//
//  Created by Derek Bronston on 2/16/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import UIKit
import OHHTTPStubs

class BDTestsMain  {
    
    //DEFAULT ENVIORNMENT NAME, USED TO DETERMINE IF WE ARE IN TEST MODE. CHANGE FTO YOUR ENVIORMENT
    var enviornmentName = "BD-UI-TEST"
    
    //DEFAULT HTTP RESPONSE CODE TO 200
    var httpResponseCode:Int32 = 200
    
    init(enviornmentName:String?){
        if let envName = enviornmentName {
            self.enviornmentName = envName
        }
    }
    
    /*
     CREATE TEST
     */
    func createTest(jsonString:String?,jsonFile:String?,httpCode:Int32)->Bool{
        
        var created = false
        
        //SET THE HTTP RESPONSE CODE
        self.httpResponseCode = httpCode
        
        //DID WE PASS A STRING
        if jsonString != nil {
            created = self.setClipboard(json: jsonString!)
            assert(created)
        }
        
        //DID WE PASS A FILE URL
        if jsonFile != nil {
            
            //get JSON string
            guard let parsedString = self.openFileAndReadIntoString(urlString: jsonFile!) else {
                return created
            }
            //set clipboard data
            created = self.setClipboard(json: parsedString)
            assert(created)
        }
        //return success message
        return created
    }
    
    func removeTest(){
        self.removeStubs()
        UIPasteboard.remove(withName: UIPasteboardName(rawValue: self.enviornmentName))
    }
    
    /*
        READ DATA FILE INTO STRING
    */
    func openFileAndReadIntoString(urlString:String)->String?{
        if let dir = Bundle.main.path(forResource: urlString, ofType:"json"){
            do {
                let text2 = try String(contentsOfFile: dir)
                return text2
            }catch _ as NSError{
                return nil
            }
        }
        return nil
    }
    
    /*
     READ CLIPBOARD
     
     1. http code
     2. json string?
     3. json file
     
     */
    func readClipboard()->String?{
    
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName), create: true)
        
        if paste == nil { return nil }
        return paste?.string
    }
    
    /*
     SET CLIPBOARD
     pass json into clipboard for later review
     
     
     1. http code
     2. json string? 
     3. json file
    */
    func setClipboard(json:String)->Bool{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName), create: true)
        paste?.string = ""
        paste?.string = json
        
        if paste == nil { return false }
        return true
    }
    
    /*
     CONVERT JSON TO DICTIONARY
    */
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /*
    STUB NETWORK
    */
    func stubNetwork(){
        
        guard let responseText = self.readClipboard() else { return }
        
        let code = self.httpResponseCode
        stub(condition: isMethodGET()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        
        stub(condition: isMethodPOST()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        
        
        stub(condition: isMethodPUT()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        
        stub(condition: isMethodPATCH()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
        
        stub(condition: isMethodDELETE()) { request -> OHHTTPStubsResponse in
            let stubData = responseText.data(using: String.Encoding.utf8)
            return OHHTTPStubsResponse(data:stubData!, statusCode:code, headers:nil)
        }
    }
    /**
     REMOVE STUBS
    */
    func removeStubs(){
         OHHTTPStubs.removeAllStubs()
    }
    
    /*
    IS TEST
    */
    func isTest()->Bool{
        
        let paste = UIPasteboard(name: UIPasteboardName(rawValue: self.enviornmentName), create: false)
        if paste?.string != nil {
        
            return true
        }
        return false
    }
}