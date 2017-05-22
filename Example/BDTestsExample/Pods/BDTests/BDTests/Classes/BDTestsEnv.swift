//
//  BDTestsEnv.swift
//  BDTestsUnitTests
//
//  Created by Derek Bronston on 5/22/17.
//  Copyright © 2017 Derek Bronston. All rights reserved.
//

import Foundation


class BDTestsEnv {

    func testEnv()->(networkTest:Bool,modelTest:Bool){
        
        var isNetworkTest = false
        var isModelTest = false
        let bdTests = BDTests(enviornmentName: nil)
        if bdTests.isTest() {
            isNetworkTest = true
        }
        
        if bdTests.isModelTest(){
            isModelTest = true
            if let model = bdTests.readDatabaseData(){
                let helpClass = BDTestsHelper()
                if helpClass.responds(to: Selector(model)){
                    helpClass.perform(Selector(model))
                }
            }
        }
        return (isNetworkTest,isModelTest)
    }
}
