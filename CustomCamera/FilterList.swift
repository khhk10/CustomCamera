import UIKit

extension EditViewController {
    
    // フィルタのリストを作成
    func createFilterList() -> Array<Item> {
        // Item型リスト
        var list = [Item]()
        
        // CIImage
        let original = CIImage(image: image!)
        
        // clampフィルタ
        let clampImage = clampFilter(original!, inputMin: CIVector(x: 0, y: 0, z: 0, w: 0), inputMax: CIVector(x: 1.0, y: 1.0, z: 0.3, w: 0.8))
<<<<<<< HEAD
        let clamp = Item(name: "Clamp", image: clampImage, listType: .filter, sliderValue: nil)
=======
        let clamp = Item(title: "Clamp", image: clampImage, listType: .filter)
>>>>>>> origin/master
        list.append(clamp)
        
        // bloomフィルタ
        let bloomImage = bloomFilter(original!, intensity: 1.9, radius: 10)
<<<<<<< HEAD
        let bloom = Item(name: "Bloom", image: bloomImage, listType: .filter, sliderValue: nil)
=======
        let bloom = Item(title: "Bloom", image: bloomImage, listType: .filter)
>>>>>>> origin/master
        list.append(bloom)
        
        // crystalizeフィルタ
        let crystalImage = crystallizeFilter(original!, radius: 100, center: CIVector(x: 150, y: 150))
<<<<<<< HEAD
        let crystal = Item(name: "Crystal", image: crystalImage, listType: .filter, sliderValue: nil)
=======
        let crystal = Item(title: "Crystal", image: crystalImage, listType: .filter)
>>>>>>> origin/master
        list.append(crystal)
        
        // gaussianフィルタ
        let gaussianImage = gaussianFilter(original!, radius: 10)
<<<<<<< HEAD
        let gaussian = Item(name: "Gaussian", image: gaussianImage, listType: .filter, sliderValue: nil)
=======
        let gaussian = Item(title: "Gaussian", image: gaussianImage, listType: .filter)
>>>>>>> origin/master
        list.append(gaussian)
        
        // originalフィルタ
        let cgOriginal = ciContext?.createCGImage(original!, from: original!.extent)
        let uiOriginal = UIImage(cgImage: cgOriginal!, scale: 0, orientation: orientaion!)
<<<<<<< HEAD
        let ori = Item(name: "Original", image: uiOriginal, listType: .filter, sliderValue: nil)
=======
        let ori = Item(title: "Original", image: uiOriginal, listType: .filter)
>>>>>>> origin/master
        list.append(ori)
        
        return list
    }
}
