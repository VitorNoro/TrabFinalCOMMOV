//
//  HorarioHabitual+CoreDataProperties.swift
//  appInterface
//
//  Created by Vitor Noro on 14/06/2018.
//  Copyright © 2018 Vitor Noro. All rights reserved.
//
//

import Foundation
import CoreData


extension HorarioHabitual {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HorarioHabitual> {
        return NSFetchRequest<HorarioHabitual>(entityName: "HorarioHabitual")
    }

    @NSManaged public var destino: String?
    @NSManaged public var empresa: String?
    @NSManaged public var hora: String?
    @NSManaged public var id: String?

}
