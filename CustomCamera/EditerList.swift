import UIKit

extension EditViewController {
    
    // 編集リストを作成
    func createEditerList() -> Array<Item> {
        var list = [Item]()
        
        let size = CGSize(width: 70, height: 70)
        
        // 明るさ
        let brightnessIcon = UIImage(named: "brightness")
        let brightness = Item(name: "Brightness", image: brightnessIcon!, listType: .editer, sliderValue: 0.0)
        list.append(brightness)
        
        // コントラスト
        let contrastIcon = UIImage(named: "contrast")
        let contrast = Item(name: "Contrast", image: contrastIcon!, listType: .editer, sliderValue: 1.0)
        list.append(contrast)
        
        // 彩度
        let saturationIcon = UIImage(named: "saturation")
        let saturation = Item(name: "Saturation", image: saturationIcon!, listType: .editer, sliderValue: 1.0)
        list.append(saturation)
        
        // list.append(saturation)
        // list.append(saturation)
        
        return list
    }
    
}
