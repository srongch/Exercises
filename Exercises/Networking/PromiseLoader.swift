//
//  PromiseLoader.swift
//  Exercises
//
//  Created by Dumbo on 17/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import Foundation
import PromiseKit

struct PromiseLoader<T>{
    static func load(task: Promise<T>, handler: @escaping ((Swift.Result<T,Error>)-> Void)){
        firstly {
            task
        }.done { result  in
         //   print(result)
            handler(.success(result))
        }.catch {error in
            print(error.localizedDescription)
       //     fatalError("error")
            handler(.failure(error))
            //                guard let strongSelf = self else { return }
            //                strongSelf.delegate?.error(error: error.localizedDescription)
        }
    }

}
