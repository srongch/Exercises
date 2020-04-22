//
//  AlertView.swift
//  Exercises
//
//  Created by Dumbo on 19/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

struct AlertView{
    static func ifNeedShowAlert(title: String? = nil, for viewcontroller: UIViewController?, result: Swift.Result<Bool, Error>, errorClosure: @escaping ()-> Void, successClosure: @escaping ()-> Void){
        switch result {
        case .failure:
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: title != nil ? title : "Something went wrong.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                    print("Selected")
                    errorClosure()
                })
                viewcontroller?.present(alert, animated: true)
            }
        default:
            successClosure()
        }

    }
}
