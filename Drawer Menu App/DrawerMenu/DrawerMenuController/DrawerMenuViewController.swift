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
    
    let scrollView = UIScrollView()
    let tableView = UITableView()
    var menuItems: [String] = ["BEGIN", "Settings", "Contact", "Logout","Profile", "Settings", "Contact", "Logout","Profile", "Settings", "Contact", "Logout","Profile", "Settings", "Contact", "Logout","Profile", "Settings", "Contact", "Logout","Profile", "Settings", "Contact", "END"]
    var subMenuItems: [[String]] = [[" Language", " Theme"], [" Phone", " Email", " Address"]]
    var isSubMenuVisible: [Bool] = Array(repeating: false, count: 2)
    
    // Represent the current menu structure based on visibility
    var currentMenu: [String] {
        var updatedMenu: [String] = []
        for (index, item) in menuItems.enumerated() {
            updatedMenu.append(item)
            if item == "Settings" && isSubMenuVisible[0] {
                updatedMenu += subMenuItems[0]
            } else if item == "Contact" && isSubMenuVisible[1] {
                updatedMenu += subMenuItems[1]
            }
        }
        return updatedMenu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupTableView()
        //setupGestureRecognizers()
    }
    
    func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.frame = CGRect(x: 0, y: 0, width: drawerWidth, height: min(CGFloat(currentMenu.count) * 44.0, scrollView.bounds.height))
        scrollView.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Set the content size of the scrollView to match the tableView's frame
        scrollView.contentSize = tableView.frame.size
    }
    
    func setupGestureRecognizers() {
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
                tableView.frame = CGRect(x: 0, y: 0, width: width, height: min(CGFloat(currentMenu.count) * 44.0, scrollView.bounds.height))
                scrollView.contentSize = tableView.frame.size
            }
        case .ended:
            // If the user released the drag within a certain threshold, close the drawer
            if translation.x <= 50 {
                dismiss(animated: true, completion: nil)
            } else {
                // Snap back to the fully open drawer
                UIView.animate(withDuration: 0.2) {
                    self.tableView.frame = CGRect(x: 0, y: 0, width: self.drawerWidth, height: min(CGFloat(self.currentMenu.count) * 44.0, self.scrollView.bounds.height))
                    self.scrollView.contentSize = self.tableView.frame.size
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let menuItem = currentMenu[indexPath.row]
        
        if menuItem.hasPrefix(" ") {
            // Sub-menu item
            cell.textLabel?.text = "\t" + menuItem
        } else {
            // Menu item
            cell.textLabel?.text = menuItem
            if menuItem == "Settings" || menuItem == "Contact" {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = currentMenu[indexPath.row]
        
        if selectedItem.hasPrefix("  ") {
            // Handle sub-menu item click
            print(selectedItem.trimmingCharacters(in: .whitespaces))
        } else if selectedItem == "Settings" {
            // Toggle sub-menu visibility for "Settings"
            isSubMenuVisible[0].toggle()
            tableView.reloadData()
        } else if selectedItem == "Contact" {
            // Toggle sub-menu visibility for "Contact"
            isSubMenuVisible[1].toggle()
            tableView.reloadData()
        }
    }
}

