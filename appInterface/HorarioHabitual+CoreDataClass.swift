//
//  HorarioHabitual+CoreDataClass.swift
//  appInterface
//
//  Created by Vitor Noro on 14/06/2018.
//  Copyright © 2018 Vitor Noro. All rights reserved.
//
//

import Foundation
import CoreData

@objc(HorarioHabitual)
public class HorarioHabitual: NSManagedObject {
    
    static func getAll(appDel: AppDelegate) -> [HorarioHabitual]? {
        let dataFetchRequest = NSFetchRequest<HorarioHabitual>(entityName: "HorarioHabitual")
        var results : [HorarioHabitual]
        
        do{
            results = try appDel.persistentContainer.viewContext.fetch(dataFetchRequest)
            return results
        } catch{
            
        }
        return nil
    }
    
    static func insert(horario: Habitual, appDel: AppDelegate) {
        let context = appDel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HorarioHabitual", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        transc.setValue(horario.destino, forKey: "destino")
        transc.setValue(horario.empresa, forKey: "empresa")
        transc.setValue(horario.hora, forKey: "hora")
        transc.setValue(horario.id, forKey: "id")
        
        do{
            try context.save()
            print("saved!")
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        } catch{
            
        }
        
    }
    
    static func delete(appDel: AppDelegate) {
        let context = appDel.persistentContainer.viewContext
        let dataFetchRequest = NSFetchRequest<HorarioHabitual>(entityName: "HorarioHabitual")
        
        if let result = try? appDel.persistentContainer.viewContext.fetch(dataFetchRequest){
            for object in result{
                context.delete(object)
            }
        }
        
    }

}
