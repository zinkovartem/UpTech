//
//  Array+Subscript.swift
//  UpTech
//
//  Created by A.Zinkov on 7/14/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
