import UIKit
import Combine
import MovableInk

final class CatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
  enum Section {
    case genders
    case categories(Product.Gender)
  }
  
  weak var coordinator: CatalogCoordinator?
  let section: Section
  
  private var list: [String]
  private var isSearching: Bool = false
  private var searchResults: [Product] = []
  
  @Published private var searchQuery: String = ""
  private var subscriptions: Set<AnyCancellable> = []
  
  private lazy var tableView: UITableView = {
    let view = UITableView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    view.dataSource = self
    return view
  }()
  
  private lazy var searchController: UISearchController = {
    let view = UISearchController()
    view.searchResultsUpdater = self
    view.obscuresBackgroundDuringPresentation = false
    view.searchBar.placeholder = "Search"
    view.searchBar.tintColor = .white
    return view
  }()
  
  init(section: Section) {
    self.section = section
    
    switch section {
    case .genders:
      self.list = Product.Gender.allCases.map(\.rawValue)
      
    case let .categories(gender):
      self.list = Product.categoriesForGender(gender).map(\.rawValue)
    }
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch section {
    case .genders:
      navigationItem.searchController = searchController
      
      // We only want to update the UI when the user is done typing.
      // A debouncing chain for when search text is updated
      let searchUpdated = $searchQuery
        .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        .share()
      
      // when there is no query
      searchUpdated
        .filter { $0.isEmpty }
        .sink { [weak self] query in
          guard let self else { return }
          
          self.isSearching = false
          self.searchResults = []
          self.tableView.reloadData()
        }.store(in: &subscriptions)
      
      // when there is a query
      searchUpdated
        .filter { !$0.isEmpty }
        .sink { [weak self] query in
          guard let self else { return }
          
          self.isSearching = true
          self.searchResults = Product.mock.filter { $0.name.contains(query) }
          self.tableView.reloadData()
          
          MIClient.productSearched(properties: .init(query: query))
        }.store(in: &subscriptions)
      
    default:
      break
    }
    
    layout()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    searchQuery = searchController.searchBar.text ?? ""
  }
}

// MARK: - Layout

private extension CatalogViewController {
  func layout() {
    switch self.section {
    case .genders:
      title = "Catalog"
      
    case let .categories(gender):
      title = gender.title
    }
    
    view.backgroundColor = .white
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    let empty = UIView()
    empty.backgroundColor = .white
    
    tableView.tableFooterView = empty
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
}

// MARK: - TableView

extension CatalogViewController {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    isSearching ? searchResults.count : list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    switch isSearching {
    case true:
      let value = searchResults[indexPath.row]
      var config = cell.defaultContentConfiguration()
      config.text = value.name
      
      cell.accessoryType = .disclosureIndicator
      cell.contentConfiguration = config
      
      return cell
      
    case false:
      switch self.section {
      case .genders:
        let value = Product.Gender(rawValue: list[indexPath.row])!
        
        var config = cell.defaultContentConfiguration()
        config.text = value.title
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = config
        
        return cell
        
      case .categories:
        let value = Product.Category(rawValue: list[indexPath.row])!
        
        var config = cell.defaultContentConfiguration()
        config.text = value.title
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = config
        
        return cell
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch isSearching {
    case true:
      coordinator?.showProduct(searchResults[indexPath.row])
      
    case false:
      switch self.section {
      case .genders:
        let gender = Product.Gender(rawValue: list[indexPath.row])!
        coordinator?.showCategories(for: gender)
        
      case .categories:
        let category = Product.Category(rawValue: list[indexPath.row])!
        coordinator?.showProducts(in: category)
      }
    }
  }
}
