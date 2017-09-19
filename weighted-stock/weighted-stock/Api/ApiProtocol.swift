//
//  ApiProtocol.swift
//  weighted-stock
//
//  Created by TimChen on 2017/9/19.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import Foundation

protocol ApiProtocol {
    func complete(api : WeightedStockListApi) -> Void
    func error(error : Error) -> Void
}
