//
//  playground.swift
//  
//
//  Created by Hanna Skairipa on 6/17/26.
//

import Playgrounds

#Playground {
    let powerUssage = Quantity(value: 1, unit: Units.kilowatt)
    let usageDuration = Quantity(value: 10, unit: Units.hour)
    
    let energyUssage = powerUssage * usageDuration
    
    print(energyUssage)
}
