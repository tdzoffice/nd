import UIKit

class DrawerMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let transitionManager = DrawerTransitionManager()
    let drawerWidth: CGFloat = UIScreen.main.bounds.width * 0.8 // Set the width to 75% of the screen width
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView = UITableView()
    let menuItems = ["Profile", "Settings"]
    var subMenuItems: [String] = ["Language","Theme"]
    var isSubMenuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupGestureRecognizers()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: 0, width: drawerWidth, height: view.bounds.height)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupGestureRecognizers() {
        // Add a pan gesture recognizer to the tableView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        tableView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            // Check if the user is dragging the tableView from the left edge
            if translation.x > 0 && translation.x <= 50 {
                let width = drawerWidth - translation.x
                tableView.frame = CGRect(x: 0, y: 0, width: width, height: view.bounds.height)
            }
        case .ended:
            // If the user released the drag within a certain threshold, close the drawer
            if translation.x <= 50 {
                dismiss(animated: true, completion: nil)
            } else {
                // Snap back to the fully open drawer
                UIView.animate(withDuration: 0.2) {
                    self.tableView.frame = CGRect(x: 0, y: 0, width: self.drawerWidth, height: self.view.bounds.height)
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSubMenuVisible ? menuItems.count + subMenuItems.count : menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row < menuItems.count {
            cell.textLabel?.text = menuItems[indexPath.row]
        } else {
            cell.textLabel?.text = subMenuItems[indexPath.row - menuItems.count]
        }
        
        if indexPath.row == 1 {
            cell.accessoryType = isSubMenuVisible ? .disclosureIndicator : .none
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            // User clicked "Settings," show or hide sub-menu items
            isSubMenuVisible.toggle()
            tableView.reloadData()
        } else {
            // Handle navigation or sub-menu item click
            if isSubMenuVisible {
                switch indexPath.row {
                case 0:
                    print("Language")
                case 1:
                    print("Theme")
                default:
                    break
                }
            } else {
                switch indexPath.row {
                case 0:
                    print("Profile")
                default:
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            cell.textLabel?.text = isSubMenuVisible ? "Settings" : "Settings"
            cell.accessoryType = isSubMenuVisible ? .disclosureIndicator : .none
        }
    }
}

