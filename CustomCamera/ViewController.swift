import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    
    // セッション
    // （キャプチャデバイスへのアクセスと、入力から出力へのデータの流れを管理する）
    var session = AVCaptureSession()
    
    // 出力（入力から提供されたデータを使用し、画像ファイルなどのメディアを作成する）
    // capturing photo用の出力
    var photoOutput = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // セッションの設定
        configure()
        
        // プレビューの設定
        setPreview()
        
        // セッション開始（入力から出力へデータが送られる）
        session.startRunning()
    }
    
    // セッションの設定
    func configure() {
        // 一連の設定変更を開始
        session.beginConfiguration()
        
        // ビットレート設定 -> 高解像度カメラ
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        // デバイスの設定（広角カメラ、メディアタイプは動画、背面カメラ）
        let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.back)
        
        // 入力（デバイスからセッションにメディアを提供する）
        do {
            let deviceInput = try AVCaptureDeviceInput(device: device!)
            // セッションに入力を追加
            guard session.canAddInput(deviceInput) else {
                print("cannot add input")
                return
            }
            session.addInput(deviceInput)
        } catch {
            print("Error: device input")
            return
        }
        
        // 出力
        guard session.canAddOutput(photoOutput) else {
            print("cannot add output")
            return
        }
        session.addOutput(photoOutput)
        
        // 一連の設定変更を更新
        session.commitConfiguration()
        
        print("add input and output")
    }
    
    func setPreview() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = cameraView.bounds
        previewLayer.masksToBounds = true
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        cameraView.layer.addSublayer(previewLayer)
        
        print("set preview layer")
    }
    
    @IBAction func cameraButtonTap(_ sender: UIButton) {
        // キャプチャの設定
        var photoSetting = AVCapturePhotoSettings()
        
        // HEVC (High Efficiency Video Codec)
        /*
         if self.photoOutput.availablePhotoFileTypes.contains(AVFileType.heic) {
         photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.hevc])
         }*/
        
        // 自動フラッシュ
        photoSetting.flashMode = AVCaptureDevice.FlashMode.auto
        // 最高の解像度でキャプチャするかどうか
        photoSetting.isHighResolutionPhotoEnabled = false
        // キャプチャ
        photoOutput.capturePhoto(with: photoSetting, delegate: self)
    }
    
    // ---- デリゲートメソッド ----
    
    // 深度データとポートレイト効果の処理が終了した時に呼ばれる
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // Data型で取得
        guard let data = photo.fileDataRepresentation() else {
            print("データなし")
            return
        }
        guard let image = UIImage(data: data) else {
            print("UIImageの生成失敗")
            return
        }
        // アルバムに保存
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
    
    // 写真のキャプチャが終了した時に呼ばれる
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
    }
}

