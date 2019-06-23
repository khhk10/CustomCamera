import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var editView: UIImageView!
    
    // 撮影された画像
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editView.image = image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
