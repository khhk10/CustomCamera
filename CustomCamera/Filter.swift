import UIKit

extension EditViewController {
    // clampフィルタ
    func clampFilter(_ input: CIImage, inputMin: CIVector, inputMax: CIVector) -> UIImage {
        let clampFilter = CIFilter(name: "CIColorClamp")
        clampFilter?.setValue(input, forKey: kCIInputImageKey)
        clampFilter?.setValue(inputMin, forKey: "inputMinComponents")
        clampFilter?.setValue(inputMax, forKey: "inputMaxComponents")
        
        // CIIImage取得
        guard let ciClamp = clampFilter?.outputImage else {
            return UIImage(ciImage: input)
        }
        // CGImage生成
        guard let cgClamp = ciContext?.createCGImage(ciClamp, from: ciClamp.extent) else {
            return UIImage(ciImage: input)
        }
        // UIImage生成
        let uiClamp = UIImage(cgImage: cgClamp, scale: 0, orientation: orientaion!)
        
        return uiClamp
    }
    
    // bloomフィルタ
    func bloomFilter(_ input: CIImage, intensity: Double, radius: Double) -> UIImage {
        let bloomFilter = CIFilter(name: "CIBloom")
        bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        
        // CIImage取得
        guard let ciBloom = bloomFilter?.outputImage else {
            return UIImage(ciImage: input)
        }
        // CGImage取得
        guard let cgBloom = ciContext?.createCGImage(ciBloom, from: ciBloom.extent) else {
            return UIImage(ciImage: input)
        }
        // UIImage生成
        let uiBloom = UIImage(cgImage: cgBloom, scale: 0, orientation: orientaion!)
        
        return uiBloom
    }
    
    // crystallizeフィルタ
    func crystallizeFilter(_ input: CIImage, radius: Double, center: CIVector) -> UIImage {
        let crystaFilter = CIFilter(name: "CICrystallize")
        crystaFilter?.setValue(input, forKey: kCIInputImageKey)
        crystaFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        crystaFilter?.setValue(center, forKey: kCIInputCenterKey)
        
        // CIIImage取得
        guard let ciCrystal = crystaFilter?.outputImage else {
            return UIImage(ciImage: input)
        }
        // CGImage生成
        guard let cgCrystal = ciContext?.createCGImage(ciCrystal, from: ciCrystal.extent) else {
            return UIImage(ciImage: input)
        }
        // UIImage生成
        let uiCrystal = UIImage(cgImage: cgCrystal, scale: 0, orientation: orientaion!)
        
        return uiCrystal
    }
    
    // gaussianフィルタ
    func gaussianFilter(_ input: CIImage, radius: Double) -> UIImage {
        let gaussianFilter = CIFilter(name: "CIGaussianBlur")
        gaussianFilter?.setValue(input, forKey: kCIInputImageKey)
        gaussianFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        
        // CIIImage取得
        guard let ciGaussian = gaussianFilter?.outputImage else {
            return UIImage(ciImage: input)
        }
        // CGImage生成
        guard let cgGaussian = ciContext?.createCGImage(ciGaussian, from: ciGaussian.extent) else {
            return UIImage(ciImage: input)
        }
        // UIImage生成
        let uiGaussian = UIImage(cgImage: cgGaussian, scale: 0, orientation: orientaion!)
        
        return uiGaussian
    }
}
