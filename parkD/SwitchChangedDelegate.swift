//
//  SwitchChangedDelegate.swift
//  parkD
//
//  Created by Adam on 12/4/16.
//  Copyright © 2016 ece590. All rights reserved.
//

protocol SwitchChangedDelegate {
    func changeStateTo(isOn: Bool, row: Int)
}
