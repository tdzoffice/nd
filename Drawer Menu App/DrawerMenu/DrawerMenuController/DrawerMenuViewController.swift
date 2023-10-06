//
//  DrawerMenuViewController.swift
//  Drawer Menu App
//
//  Created by Artem Korzh on 26.09.2020.
//

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
    var subMenuItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupGestureRecognizers()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: drawerWidth, height: view.bounds.height)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Add a pan gesture recognizer to the tableView
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
                tableView.addGestureRecognizer(panGesture)
    }
    
    func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Check if the tap is outside the drawer area, then close the drawer
            let location = sender.location(in: view)
            if location.x > drawerWidth {
                dismiss(animated: true, completion: nil)
            }
        }
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
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        
        if indexPath.row == 1 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            // User clicked "Settings," show sub-menu items
            subMenuItems = ["Language", "Theme"]
            tableView.reloadData()
        } else {
            // Handle navigation to other pages (e.g., "Profile")
            switch indexPath.row {
            case 0:
                // Navigate to Profile page
                break
            case 1:
                // Show subMenuItems = ["Language", "Theme"]
                break
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && subMenuItems.count > 0 {
            return 50 // Adjust the height for sub-menu items
        }
        return 44 // Default cell height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && subMenuItems.count > 0 {
            cell.textLabel?.text = "Settings >"
            cell.accessoryType = .disclosureIndicator
        }
    }
}
