//
//  ItemDetailsVC.swift
//  DreamList
//
//  Created by Abraham Barcenas M on 1/14/17.
//  Copyright © 2017 bardev. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var storePicker : UIPickerView!
    @IBOutlet var titleField : CustomTextField!
    @IBOutlet var priceField : CustomTextField!
    @IBOutlet var detailsField : CustomTextField!
    @IBOutlet var thumbImage: UIImageView!
    
    var stores : [Store] = []
    var itemTypes : [ItemType] = []
    var itemToEdit : Item?
    var imagePicker : UIImagePickerController!
    
    var seleccionoImagen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        storePicker.delegate = self
        storePicker.dataSource = self
        
        //testStoreData()
        //testItemTypeData()
        getStores()
        getTypes()
        
        if itemToEdit != nil{
            loadItemData()
        }

    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return stores.count
        case 1:
            return itemTypes.count
        default:
            break
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            let myStore = stores[row]
            return myStore.name
        }else{
            let myItemTypes = itemTypes[row]
            return myItemTypes.type
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
    }
    
    func getStores(){
        
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        
        do{
            self.stores =  try context.fetch(fetchRequest)
            //self.storePicker.reloadAllComponents()
        } catch {
            //handle Error
        }
    }
    
    func getTypes(){
        
        let fetchRequest : NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do{
            self.itemTypes =  try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            //handle Error
        }
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        var item : Item!
        //let picture = Image(context: context)
        //picture.image = thumbImage.image
        
        var picture : Image?
        
        if itemToEdit == nil{
             item = Item(context: context)
            
            picture? = Image(context: context)
            picture?.image = thumbImage.image
            item.toImage = picture
        }else{
            item = itemToEdit
            
            if seleccionoImagen {
                picture = Image(context: context)
                picture?.image = thumbImage.image
                item.toImage = picture
            }
        }
        
        if let title  = titleField.text{
            item.title = title
        }
        
        if let price = priceField.text{
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text{
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadItemData(){
        
        if let item = itemToEdit{
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore{
                
                var index = 0
                repeat{
                    
                    let s = stores[index]
                    if s.name == store.name{
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                }while (index < stores.count)
            }
            
            if let itemType = item.toItemType{
                var index = 0
                repeat{
                    let it = itemTypes[index]
                    if it.type == itemType.type{
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                    }
                    index += 1
                }while (index < itemTypes.count)
            }
        }
    }
    
    
    @IBAction func deletePressed(_ sender: Any) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
            
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            thumbImage.image = img
            dismiss(animated: true, completion: nil)
            seleccionoImagen = true
        }
    }
    
    
    func testStoreData(){
        //Test Data for CoreData
        
        let newStore = Store(context: context)
        newStore.name = "Best Buy"
        
        let newStore2 = Store(context: context)
        newStore2.name = "Tesla Dealership"
        
        let newStore3 = Store(context: context)
        newStore3.name = "Frys Electronics"
        
        let newStore4 = Store(context: context)
        newStore4.name = "Target"
        
        let newStore5 = Store(context: context)
        newStore5.name = "Amazon"
        
        let newStore6 = Store(context: context)
        newStore6.name = "K Mart"
        
        ad.saveContext()
    }
    
    func testItemTypeData(){
        //Test Data for CoreData
        
        let itemType = ItemType(context: context)
        itemType.type = "Electronics"
        
        let itemType2 = ItemType(context: context)
        itemType2.type = "Toys"
        
        let itemType3 = ItemType(context: context)
        itemType3.type = "Automovile"
        
        let itemType4 = ItemType(context: context)
        itemType4.type = "Clothing"
        
        let itemType5 = ItemType(context: context)
        itemType5.type = "Home"
        
        ad.saveContext()
    }
    

}
