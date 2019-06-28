import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // カメラビュー
    @IBOutlet weak var cameraView: UIView!
    
    // 保存された写真
    var capturedImage: UIImage?
    
    // front or back camera
    var isFrontCamera = false
    
    // セッション
    // （キャプチャデバイスへのアクセスと、入力から出力へのデータの流れを管理する）
    var session = AVCaptureSession()
    
    // 入力
    var deviceInput: AVCaptureDeviceInput?
    
    // 出力（入力から提供されたデータを使用し、画像ファイルなどのメディアを作成する）
    // capturing photo用の出力
    var photoOutput = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // セッション実行中
        if session.isRunning {
            return
        }
        
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
            deviceInput = try AVCaptureDeviceInput(device: device!)
            // セッションに入力を追加
            guard session.canAddInput(deviceInput!) else {
                print("cannot add input")
                return
            }
            session.addInput(deviceInput!)
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
    
    // プレビュー設定
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
    
    // カメラを変える
    @IBAction func changeFrontBack(_ sender: Any) {
        session.beginConfiguration()
        
        // 以前の入力を削除
        session.removeInput(deviceInput!)
        
        let cameraPosition: AVCaptureDevice.Position
        if isFrontCamera {
            // front -> back
            isFrontCamera = false
            cameraPosition = .back
        } else {
            // back -> front
            isFrontCamera = true
            cameraPosition = .front
        }
        
        // デバイスを取得
        let deviceDicoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let deviceArray = deviceDicoverySession.devices
        print("##devices: \(deviceArray)")
        
        var newDevice: AVCaptureDevice!
        for device in deviceArray {
            newDevice = device
            if device.position == cameraPosition {
                break
            }
        }
        // let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)
        
        do {
            //  新しい入力
            let newDeviceInput = try AVCaptureDeviceInput(device: newDevice)
            // 入力を追加できるかどうか
            if session.canAddInput(newDeviceInput) {
                // 新しい入力を追加
                session.addInput(newDeviceInput)
                deviceInput = newDeviceInput
            } else {
                // 以前の入力
                session.addInput(deviceInput!)
            }
        } catch {
            print("Error: device input")
            // 以前の入力
            session.addInput(deviceInput!)
        }
        
        /*
        guard let input = session.inputs.first else {
            return
        }*/
        session.commitConfiguration()
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
        
        capturedImage = image
        
        // アルバムに保存
        // UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        
        // 編集画面へ遷移
        goToEditpage()
    }
    
    // 写真のキャプチャが終了した時に呼ばれる
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
    }
    
    // 編集画面へ遷移
    func goToEditpage() {
        // 識別子を指定してインスタンス生成
        guard let editViewController = self.storyboard?.instantiateViewController(withIdentifier: "editPage") as? EditViewController else {
            return
        }
        
        // 撮影された画像
        editViewController.image = capturedImage
        // トランジションのスタイル
        editViewController.modalTransitionStyle = .crossDissolve
        
        // プレビュー画像を設定
        present(editViewController, animated: true, completion: nil)
    }
}

