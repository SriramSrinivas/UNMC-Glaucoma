//
//  PatientData.swift
//  glacInit
//
//  Created by Parshav Chauhan on 7/27/17.
//  Copyright © 2017 Parshav Chauhan. All rights reserved.
//
import RealmSwift

class PatientData : Object{
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}

enum Effect {
    case None, Blur, Luminous, ObjectHidden
}
