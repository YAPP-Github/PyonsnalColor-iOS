//
//  ProductConvertable.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

import Foundation

protocol ProductConvertable: Decodable {
    var imageURL: URL { get }
    var storeType: ConvenienceStore { get }
    var updatedTime: String { get }
    var name: String { get }
    var price: String { get }
    var description: String { get }
}
 
