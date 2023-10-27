//
//  ReviewEvaluationProtocol.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/30.
//

protocol ReviewEvaluationProtocol {
    var name: String { get }
    var goodStateText: String { get }
    var normalStateText: String { get }
    var badStateText: String { get }
}
