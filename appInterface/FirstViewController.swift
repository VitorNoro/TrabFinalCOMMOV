//
//  FirstViewController.swift
//  appInterface
//
//  Created by Vitor Noro on 06/06/2018.
//  Copyright © 2018 Vitor Noro. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var array : [Horario] = []
    var horarios : [Horario] = []
    var arrayHoras : [Horario] = []
    var searchArray:Array<Horario>?
    
    let inFormatter = DateFormatter()
    let outFormatter = DateFormatter()
    let dayFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var erro: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        inFormatter.dateFormat = "HH:mm:ss"
        outFormatter.dateFormat = "HH:mm"
        dayFormatter.dateFormat = "dd.MM.yyyy"
        timeFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        if(Reachability.isConnectedToNetwork()){
            erro.text = ""
            getJSON()
        }
        else{
            erro.text = "Não está ligado à Internet"
        }
        

    }
    
    func getJSON(){
        
        let urlString = "https://testecommov.000webhostapp.com/myslim/api/horariosios"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let new = try JSONDecoder().decode([Horario].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    for hora in new{
                        
                        let inStr = hora.hora
                        let date = self.inFormatter.date(from: inStr)!
                        let outStr = self.outFormatter.string(from: date)
                        /*let today = Date()
                        let day = self.dayFormatter.string(from: today)
                        let time = "15.06.2018" + " " + outStr
                        let dateTime = self.timeFormatter.date(from: time)
                        //print(dateTime) // -> outputs 04:50
                        
                        
                        let start = Date()
                        let calendar = Calendar.current
                        let unitFlags = Set<Calendar.Component>([ .second])
                        let datecomponenets = calendar.dateComponents(unitFlags, from: start, to: dateTime!)
                        let seconds = datecomponenets.second
                        let minutes = seconds! / 60
                        print("Seconds: \(minutes)")
                        */
                        let temp = Horario(id: hora.id, hora: outStr, destino: hora.destino, empresa: hora.empresa, cais: hora.cais, tipo: hora.tipo)
                        
                        //self.array.append(temp)
                        self.horarios.append(temp)
                        
                      
                        
                        self.tableview .reloadData()
                    }
                    self.horarios = self.horarios.sorted(by: { $0.hora < $1.hora })
                    
                    self.filterTime()
                    self.thread()
                    
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
            }.resume()
        
        searchBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.backgroundColor = UIColor.clear
        cell.hora?.text = array[indexPath.row].hora
        cell.viagem?.text = array[indexPath.row].destino
        cell.empresa?.text = array[indexPath.row].empresa
        cell.cais?.text = array[indexPath.row].cais
        
        if(array[indexPath.row].tipo.lowercased() == "partida"){
            cell.hora?.textColor = UIColor.green
            cell.viagem?.textColor = UIColor.green
            cell.empresa?.textColor = UIColor.green
            cell.cais?.textColor = UIColor.green
        }
        else{
            cell.hora?.textColor = UIColor.red
            cell.viagem?.textColor = UIColor.red
            cell.empresa?.textColor = UIColor.red
            cell.cais?.textColor = UIColor.red
        }
        
         //cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton
        
        /*if arrayB[indexPath.row]{
         cell.accessoryType = UITableViewCellAccessoryType.checkmark
         }
         else{
         cell.accessoryType = UITableViewCellAccessoryType.none
         }*/

        return cell
    }
    
    /*func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editar = UITableViewRowAction(style: .default, title: "Editar"){action, index in print("editar: " + String(index.row) + " " + self.array[index.row])
            self.performSegue(withIdentifier: "segue1", sender: indexPath)
        }
        
        editar.backgroundColor = UIColor.blue
        
        let delete = UITableViewRowAction(style: .default, title: "Apagar"){action, index in
            print("apagar: " + String(index.row))
            self.array.remove(at: index.row)
            tableView.reloadData()
        }
        
        delete.backgroundColor = UIColor.red
        
        return [editar, delete]
    }*/
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     if arrayB[indexPath.row]{
     tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
     arrayB[indexPath.row] = false
     }
     else{
     tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
     arrayB[indexPath.row] = true
     }
     }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "segue1", sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        /*let alert = UIAlertController(title: "Info", message: array[indexPath.row], preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "Fechar", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         */
        
        //self.performSegue(withIdentifier: "segue1", sender: tableView)
        
        //print(indexPath.row)
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue1"){
            let idx = sender as! IndexPath
            let vcdetalhe = (segue.destination as! VCDetalhe)
            vcdetalhe.cidade = array[idx.row]
            vcdetalhe.id_cidade = idx.row
        }
    }
    
    @IBAction func unWindFromDetalheGravar(segue: UIStoryboardSegue){
        let details = segue.source as! VCDetalhe
        let cidade:String = details.txtCidade.text!
        print(cidade)
        
        if(details.id_cidade != -1){
            array.remove(at: details.id_cidade)
        }
        
        array.append(cidade)
        tableView .reloadData()
    }*/
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        array = arrayHoras.filter({ horario -> Bool in
            
                if searchText.isEmpty { return true }
                return horario.destino.lowercased().contains(searchText.lowercased())
            
        })
        tableview.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            array = arrayHoras
        default:
            break
        }
        tableview.reloadData()
    }

    func thread(){
        DispatchQueue.background(delay: 60, background: {
            
        }, completion: {
            
            self.filterTime()
            self.thread()
        })
    }
    
    func filterTime(){
        array.removeAll()
        arrayHoras.removeAll()
        
        for hora in self.horarios{
            
            
            let today = Date()
            let day = self.dayFormatter.string(from: today)
            let time = day + " " + hora.hora
            let dateTime = self.timeFormatter.date(from: time)
            //print(dateTime) // -> outputs 04:50
            
            
            let start = Date()
            let calendar = Calendar.current
            let unitFlags = Set<Calendar.Component>([ .second])
            let datecomponenets = calendar.dateComponents(unitFlags, from: start, to: dateTime!)
            let seconds = datecomponenets.second
            let minutes = seconds! / 60
            //print("Seconds: \(minutes)")
            
            if(minutes > 0 && minutes < 30){
                self.arrayHoras.append(hora)
            }
        }
        
        array = arrayHoras
        self.tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}


