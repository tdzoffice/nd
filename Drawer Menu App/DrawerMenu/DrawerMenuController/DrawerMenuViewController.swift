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
    let menuItems = ["Profile", "Settings", "Contact", "Logout"]
    var subMenuItems: [[String]] = [["Language", "Theme"], ["Phone", "Email", "Address"]]
    var isSubMenuVisible = Array(repeating: false, count: 2)
    
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
        var count = menuItems.count
        for (index, isVisible) in isSubMenuVisible.enumerated() {
            if isVisible {
                count += subMenuItems[index].count
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var adjustedIndex = indexPath.row
        for (index, isVisible) in isSubMenuVisible.enumerated() {
            if isVisible {
                let subMenuCount = subMenuItems[index].count
                if adjustedIndex < subMenuCount {
                    cell.textLabel?.text = "  " + subMenuItems[index][adjustedIndex]
                    return cell
                }
                adjustedIndex -= subMenuCount
            }
        }
        
        if adjustedIndex < menuItems.count {
            cell.textLabel?.text = menuItems[adjustedIndex]
        }
        
        cell.accessoryType = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var adjustedIndex = indexPath.row
        for (index, isVisible) in isSubMenuVisible.enumerated() {
            if isVisible {
                let subMenuCount = subMenuItems[index].count
                if adjustedIndex < subMenuCount {
                    // Handle sub-menu item click
                    let subMenuItem = subMenuItems[index][adjustedIndex]
                    print(subMenuItem)
                    return
                }
                adjustedIndex -= subMenuCount
            }
        }
        
        if adjustedIndex < menuItems.count {
            // Handle menu item click
            let menuItem = menuItems[adjustedIndex]
            print(menuItem)
            
            if adjustedIndex == 1 {
                // Toggle sub-menu visibility for "Settings"
                isSubMenuVisible[0].toggle()
                isSubMenuVisible[1] = false
                tableView.reloadData()
            } else if adjustedIndex == 2 {
                // Toggle sub-menu visibility for "Contact"
                isSubMenuVisible[1].toggle()
                isSubMenuVisible[0] = false
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var adjustedIndex = indexPath.row
        for (index, isVisible) in isSubMenuVisible.enumerated() {
            if isVisible {
                let subMenuCount = subMenuItems[index].count
                if adjustedIndex < subMenuCount {
                    // Sub-menu item
                    cell.textLabel?.text = "  " + subMenuItems[index][adjustedIndex]
                    return
                }
                adjustedIndex -= subMenuCount
            }
        }
        
        if adjustedIndex < menuItems.count {
            // Menu item
            cell.textLabel?.text = menuItems[adjustedIndex]
            if adjustedIndex == 1 || adjustedIndex == 2 {
                // Show ">" indicator for "Settings" and "Contact"
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
        }
    }
}

