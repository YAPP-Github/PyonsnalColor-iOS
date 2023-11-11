//
//  FavoriteButtonDelegate.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/11/23.
//

import Foundation

protocol FavoriteButtonDelegate: AnyObject {
    func didTapFavoriteButton(product: ProductDetailEntity, action: FavoriteButtonAction)
}
