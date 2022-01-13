//
//  ImagePicker.swift
//  ShopApp
//
//  Created by Hendrik Steen on 13.01.22.
//

import SwiftUI
import PhotosUI
//Image Picker, um ein Profilbild hochzuladen
struct ImagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    
    
    @Binding var picker: Bool
    @Binding var img_Data: Data
    
    func makeUIViewController(context: Context) ->  PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.isEmpty {
                self.parent.picker.toggle()
                return
            }
            
            let item = results.first!.itemProvider
            
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (image, err) in
                    if err != nil {return}
                    let imageData = image as! UIImage
                    DispatchQueue.main.async {
                        self.parent.img_Data = imageData.jpegData(compressionQuality: 0.5)!
                        self.parent.picker.toggle()
                    }
                }
            }
        }
    }
}
