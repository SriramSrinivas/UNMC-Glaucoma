//
//  LocalStorage.swift
//  glacInit
//
//  Created by Lyle Reinholz on 8/16/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation

class LoaclStorage {
    init() {
        
    }
    var data: [LocalFileModel] = []
    var imageData: [SaveImageData] = []
    
//fills model with data and saves the data.
func SaveFileToLocal(name: String, blurdata: String, colordata: String, greydata: String, hiddendata: String, savedata: String, image: NSData){
    let saveData = VisaulFieldData(context: PersistanceService.context)
   
    saveData.blurdata = blurdata
    saveData.colordata = colordata
    saveData.greydata = greydata
    saveData.image = image
    saveData.name = name
    saveData.savedata = savedata
    saveData.isHiddendata = hiddendata
    PersistanceService.save()
}
    
    func SaveImageToLocal(name: String, title: String, id: Int, image: Data){
        let saveData = SaveImageData(context: PersistanceService.context)
        
        saveData.id = Int16(id)
        saveData.name = name
        saveData.title = title
        saveData.image = image
        
        PersistanceService.save()
    }
    
func deleteData(data: [FilesToDownload]) {
    let LocalFileModels = PersistanceService.fetch(VisaulFieldData.self)
    for datum in data {
        for file in LocalFileModels{
            if datum.name == file.name{
                PersistanceService.context.delete(file)
            }
        }
    }
    PersistanceService.save()
}
    func deleteBackgroundImage(image: BackgroundImage) {
        let LocalFileModels = PersistanceService.fetch(SaveImageData.self)
        if (image.isImported == isBackGroundImported.imported){
            for data in LocalFileModels {
                if image.title == data.title {
                    PersistanceService.context.delete(data)
                    PersistanceService.save()
                }
            }
        }
    }
    
func loadData() throws -> [LocalFileModel] {
    let LocalFileModels = PersistanceService.fetch(VisaulFieldData.self)  //hared.fetch(VisaulFieldData.self)
    data = []
    var flag : LocalFileLoadingError?
    for file in LocalFileModels {
        let ehy  = LocalFileModel.init(name: file.name, blurdata: file.blurdata, colordata: file.colordata, greydata: file.greydata, ishiddendata: file.isHiddendata, savedata: file.savedata, image: file.image)
        do {
            try ehy.CheckData()
            //data.append(ehy)
        } catch LocalFileLoadingError.errorInDataLoading {
            flag = LocalFileLoadingError.errorInDataLoading
        } catch LocalFileLoadingError.errorInImageLoading {
            flag =  LocalFileLoadingError.errorInImageLoading
        } catch  {
            flag = LocalFileLoadingError.errorInNameLoading
        }
        data.append(ehy)
    }
    if flag == LocalFileLoadingError.errorInDataLoading {
        throw flag!
    }
    if flag == LocalFileLoadingError.errorInImageLoading {
        throw flag!
    }
    if flag == LocalFileLoadingError.errorInNameLoading {
        throw flag!
    }
    return data
}
func getDataThatDidLoad() -> [LocalFileModel] {
    return data
}
}
