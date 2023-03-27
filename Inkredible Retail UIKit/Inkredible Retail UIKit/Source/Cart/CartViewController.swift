import UIKit
import Combine

final class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  weak var coordinator: CartCoordinator?
  
  private var subscriptions: Set<AnyCancellable> = []
  
  private var isDeletingBySwipe: Bool = false
  private var isCartEmpty: Bool = true {
    didSet {
      if isCartEmpty {
        self.contentView.isHidden = true
        self.emptyDataSet.isHidden = false
      } else {
        self.contentView.isHidden = false
        self.emptyDataSet.isHidden = true
        self.tableView.reloadData()
        
        if self.tableView.contentSize.height > self.tableView.bounds.height - 100 {
          self.footer.layer.shadowOpacity = 0.1
        } else {
          self.footer.layer.shadowOpacity = 0
        }
      }
    }
  }
  
  private lazy var emptyDataSet: EmptyDataSet = {
    let view = EmptyDataSet()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layout.update(
      config: .init(title: "Cart is empty!")
    )
    
    return view
  }()
  
  private lazy var tableView: UITableView = {
    let view = UITableView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    view.dataSource = self
    return view
  }()
  
  private lazy var footer: Component<StackedTextWithButtonLayout> = {
    var config = UIButton.Configuration.tinted()
    config.title = "Buy Now"
    config.baseForegroundColor = .white
    config.background.backgroundColor = .systemBlue
    config.cornerStyle = .medium
    
    let view = Component<StackedTextWithButtonLayout>()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layout.titleLabel.text = "Cart Total"
    view.layout.subtitleLabel.text = Cart.shared.totalFormatted
    view.layout.update(
      buttonConfiguration: config,
      buttonAction: .init(
        handler: { [weak self] _ in
          guard let self else { return }
          
          self.coordinator?.showAskBuyNowAlert()
        }
      )
    )
    view.backgroundColor = .white
    
    // Creates shadow and caches it
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.1
    view.layer.shadowOffset = .init(width: 0, height: -3)
    view.layer.shadowRadius = 5
    view.layer.shouldRasterize = true
    view.layer.rasterizationScale = UIScreen.main.scale
    
    return view
  }()
  
  /// A UIView that contains the ui for the cart.
  ///
  /// This helps with hiding/showing content and the emptyDataSet
  private lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    view.addSubview(footer)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: footer.topAnchor),
      
      footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      footer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      footer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
    ])
    
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layout()
    bind()
    
    // Hides the shadow for now
    footer.layer.shadowOpacity = 0
  }
}

private extension CartViewController {
  func layout() {
    title = "Cart"
    view.backgroundColor = .white
    
    view.addSubview(contentView)
    view.addSubview(emptyDataSet)
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: view.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      emptyDataSet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      emptyDataSet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      emptyDataSet.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    
    let empty = UIView()
    empty.backgroundColor = .white
    
    tableView.tableFooterView = empty
    
    CartListItemTableViewCell.register(tableView: tableView)
  }
  
  func bind() {
    // Sink to update which view, tableview or emptyDataSet is shown on screen
    // This also will update the tableview if it needs to
    Cart.shared.$count
      .sink { [weak self] count in
        guard let self else { return }
        
        // If we're swipe to deleting, we don't want to update the tableview
        // until it's done it's work
        guard !self.isDeletingBySwipe else { return }
        
        // If there are no items in the cart, show the emptyDataSet,
        // otherwise, show the list of items
        self.isCartEmpty = count < 1
      }.store(in: &subscriptions)
    
    // Sink to update the Cart Total Text in the footer when the total changes
    Cart.shared.$total
      .sink { [weak self] total in
        guard let self else { return }
        
        self.footer.layout.subtitleLabel.text = (total / 100).formatted(.currency(code: "usd"))
      }.store(in: &subscriptions)
  }
}

// MARK: - TableView

extension CartViewController {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Cart.shared.products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = CartListItemTableViewCell.cell(forTable: tableView, indexPath: indexPath)
    
    let product = Cart.shared.products[indexPath.row]
    
    cell.configure(with: product, quantity: Cart.shared.items[product] ?? 0)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.isDeletingBySwipe = true
      
      let product = Cart.shared.products[indexPath.row]
      Cart.shared.remove(product: product)
      tableView.deleteRows(at: [indexPath], with: .fade)
      
      self.isDeletingBySwipe = false
      
      if Cart.shared.count < 1 {
        self.isCartEmpty = true
      }
    }
  }
}
