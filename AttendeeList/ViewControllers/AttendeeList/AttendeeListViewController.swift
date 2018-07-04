import Foundation
import UIKit
import CoreData

/*
 
 For storing attendees locally I use CoreData
 It's integrated into View Controller as part of fetchResultController that performs fetch from Core Data
 
 I didn't used fetchResultsController delegate, because according to the task description, we retrieve all attendees (there is no pagination for the request),
 so there is no need to update table view in real time with new data
 Table view is configured to fetch through Attendee entity in the Core Data storage
 Defauls sort is by attendee id
 
 */

class AttendeeListViewController: UIViewController {
    static let showAttendeeDetailsSequeId = "ShowAttendeeDetails"
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    private(set) var viewModel = AttendeeListViewModel()
    
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table view is hidden till the download attendee request is active and retrieved attendees are saved into Core Data
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.isHidden = true
        
        tableView?.register(UINib(nibName: AttendeeListCell.defaultReuseIdentifier, bundle: nil),
                            forCellReuseIdentifier: AttendeeListCell.defaultReuseIdentifier)
        
        configureFetchController()
        
        // Callback to configure view controller
        // after downloading and saving attendees is done
        viewModel.attendeesDownloaded = { [weak self] in
            self?.showResults()
            self?.fetchLocalData()
            self?.tableView?.reloadData()
        }
        
        viewModel.attendeeListSortTypeDidChange = { [weak self] in
            self?.configureFetchController()
            self?.fetchLocalData()
            self?.tableView?.reloadData()
        }
        
        viewModel.filterTextHasChanged = { [weak self] in
            self?.configureFetchController()
            self?.fetchLocalData()
            self?.tableView?.reloadData()
        }
        
        addNavigatonBarButtons()
        
        // Retrieve attendees from the server
        viewModel.retrieveAttendeeList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Attendee List"
        
        fetchLocalData()
        tableView?.reloadData()
    }
    
    // Configure Atendee Details View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.title = ""
        
        if let controller = segue.destination as? AttendeeDetailsViewController,
            let indexPath = sender as? IndexPath {
            if let attendee = fetchResultController?.object(at: indexPath) as? Attendee {
                controller.viewModel = AttendeeDetailsViewModel(attendee)
            }
        }
    }
    
    func configureFetchController() {
        var predicate: NSCompoundPredicate?
        if let filter = viewModel.filterText, filter.count > 0 {
            let predicate1 = NSPredicate(format: "firstName contains[c] '\(filter)'")
            let predicate2 = NSPredicate(format: "lastName contains[c] '\(filter)'")
            let predicate3 = NSPredicate(format: "company contains[c] '\(filter)'")
            predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        }
        
        let fetchRequest = Attendee.fetchRequestFromDefaultContextWithPredicate(predicate,
                                                                                sortDescriptors: [NSSortDescriptor(key: viewModel.attendeeListSortType.sortDescriptorValues.value,
                                                                                                                   ascending: viewModel.attendeeListSortType.sortDescriptorValues.ascending)])
        
        self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: AppDelegate.shared.persistentContainer.viewContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
    }
    
    func fetchLocalData() {
        do {
            try fetchResultController?.performFetch()
        } catch {
            print("\n-------Error due to fetching data in \(String(describing: self))-------\n")
        }
    }
    
    private func addNavigatonBarButtons() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Name, Company"
        navigationItem.searchController = searchController
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortButtonTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearButtonTapped))
    }
    
    private func showResults() {
        self.activityIndicator?.stopAnimating()
        self.tableView?.isHidden = false
    }
    
    @objc private func sortButtonTapped() {
        UIAlertController.showActionSheetWithButtonTitles(buttonTitles: viewModel.sortTitles, inViewController: self) { [weak self] (selection) in
            guard let strongSelf = self else { return }
            if let choice = selection, let sortType = AttendeeListSortType(rawValue: choice) {
                strongSelf.viewModel.attendeeListSortType = sortType
            }
        }
    }
    
    @objc private func clearButtonTapped() {
        viewModel.attendeeListSortType = .id
        viewModel.filterText = nil
    }
    
}

extension AttendeeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttendeeListCell.defaultReuseIdentifier, for: indexPath)
        if let attendee = fetchResultController?.object(at: indexPath) as? Attendee,
            let attendeeCell = cell as? AttendeeListCell {
            attendeeCell.customizeCellWithAttendee(attendee, indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchResultController?.fetchedObjects?.count
        if let _ = count {
            // Objects exists locally
            showResults()
        }
        return count ?? 0
    }
}

extension AttendeeListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: AttendeeListViewController.showAttendeeDetailsSequeId,
                          sender: indexPath)
    }
    
}

extension AttendeeListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterText = searchController.searchBar.text
    }
}
