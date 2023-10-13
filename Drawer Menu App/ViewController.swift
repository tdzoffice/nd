
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sendHttp2(url: "www.google.com", connections: 9, requestsPerConnection: 999)
    }

    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController()
        present(drawerController, animated: true)
    }
}

