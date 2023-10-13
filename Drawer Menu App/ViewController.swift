
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            //sendHttp2(url: "www.google.com", connections: 9, requestsPerConnection: 2635)
            slowHttp(url: "https://.com", connections: 2000, delay: 1)
        }
        
        
    }

    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController()
        present(drawerController, animated: true)
    }
}

