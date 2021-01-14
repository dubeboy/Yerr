//
//  Sequence+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/11.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

extension Collection {
    
    func get(_ index: Index) -> Iterator.Element? {
        self.indices.contains(index) ? self[index] : nil
    }
    
}
