
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapMenu(_ sender: Any) {
        let drawerController = DrawerMenuViewController()
        present(drawerController, animated: true)
    }
}

