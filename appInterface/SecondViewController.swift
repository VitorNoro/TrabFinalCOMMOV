//
//  SecondViewController.swift
//  appInterface
//
//  Created by Vitor Noro on 06/06/2018.
//  Copyright © 2018 Vitor Noro. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var array : [Habitual] = []
    var horarios : [Habitual] = []
    var delegate : AppDelegate?
    let inFormatter = DateFormatter()
    let outFormatter = DateFormatter()
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        delegate = UIApplication.shared.delegate as? AppDelegate
        
        inFormatter.dateFormat = "HH:mm:ss"
        outFormatter.dateFormat = "HH:mm"
        
        self.picker.delegate = self
        self.picker.dataSource = self
        if Reachability.isConnectedToNetwork(){
            getJSON()
        }
        else{
            if let core = HorarioHabitual.getAll(appDel: self.delegate!) {
                if(core.count > 0){
                    for hora:HorarioHabitual in core{
                        let temp = Habitual(id: hora.id!, hora: hora.hora!, destino: hora.destino!, empresa:hora.empresa!)
                        /*temp.destino = hora.destino
                         temp.hora = hora.hora
                         temp.empresa = hora.empresa
                         */
                        self.horarios.append(temp)
                        
                        print(temp)
                        
                    }
                    
                    readyUp()
                }
            }
        }
    }
    
    func getJSON(){
        
        let urlString = "https://testecommov.000webhostapp.com/myslim/api/horariosHabituais"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let new = try JSONDecoder().decode([Habitual].self, from: data)
                
                if let core = HorarioHabitual.getAll(appDel: self.delegate!) {
                    //Get back to the main queue
                    DispatchQueue.main.async {
                        if(core.count > 0){
                            HorarioHabitual.delete(appDel: self.delegate!)
                            /*for hora:HorarioHabitual in core{
                                let temp = Habitual(id: hora.id!, hora: hora.hora!, destino: hora.destino!, empresa:hora.empresa!)
                                /*temp.destino = hora.destino
                                 temp.hora = hora.hora
                                 temp.empresa = hora.empresa
                                 */
                                self.horarios.append(temp)
                                HorarioHabitual.insert(horario: temp, appDel: self.delegate!)
                                
                                print(temp)
                                
                            }
                            
                            print("Está guardado")*/
                        }
                        
                        for hora in new{
                            
                            
                            let inStr = hora.hora
                            let date = self.inFormatter.date(from: inStr)!
                            let outStr = self.outFormatter.string(from: date)
                            
                            let temp = Habitual(id: hora.id, hora: outStr, destino: hora.destino, empresa:hora.empresa)
                           
                            self.horarios.append(temp)
                            HorarioHabitual.insert(horario: temp, appDel: self.delegate!)
                            
                            print(hora)
                            
                        }
                        
                        self.readyUp()
                }
                    
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
            }.resume()
        
    }
    
    func readyUp(){
        
        
        for hora in self.horarios{
            if !(self.pickerData.contains(hora.destino)){
                self.pickerData.append(hora.destino)
                self.picker.reloadAllComponents()
            }
        }
        
        self.horarios = self.horarios.sorted(by: { $0.hora < $1.hora })
        
        self.array = self.horarios.filter({ horario -> Bool in
            return horario.destino.lowercased().contains(self.pickerData[0].lowercased())
        })
        self.tableview.reloadData()
    }
    
    /*func addPais() {
        Pais.insert(nome: textoPais1.text!, appDel: delegate!)
        textoPais1.text = ""
    }
    
    func updatePais() {
        Pais.update(nomeAntigo: textoPaisAntigo.text!, nomeNovo: textoPaisNovo.text!, appDel: delegate!)
    }
    
    func todasAsCidades() {
        var result:String! = ""
        
        if let arr = Cidade.getAll(appDel: delegate!){
            for c:Cidade in arr {
                result = result + ";" + c.nome!
                if let p:Pais = c.tem_pais {
                    result = result + "(" + p.nome! + ")"
                }
            }
        }
    }
    
    @IBAction func allPaises(_ sender: Any) {
        var result:String! = ""
        if let arr = Pais.getAll(appDel: delegate!){
            for p:Pais in arr {
                result = result + ";" + p.nome!
            }
        }
        
        label3.text = result
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellHabitual
        cell.backgroundColor = UIColor.clear
        cell.hora?.text = array[indexPath.row].hora
        cell.destino?.text = array[indexPath.row].destino
        cell.empresa?.text = array[indexPath.row].empresa

        return cell
    }
    

    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        array = horarios.filter({ horario -> Bool in
            return horario.destino.lowercased().contains(pickerData[row].lowercased())
        })
        tableview.reloadData()
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


