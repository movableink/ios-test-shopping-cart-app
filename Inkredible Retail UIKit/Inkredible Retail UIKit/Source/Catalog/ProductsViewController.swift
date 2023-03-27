import UIKit

final class ProductsViewController: UIViewController, UICollectionViewDelegate {
  weak var coordinator: CatalogCoordinator?
  private(set) var category: Product.Category

  private var products: [Product]
  private var dataSource: UICollectionViewDiffableDataSource<Int, Product>!
  private lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    
    return view
  }()
  
  init(category: Product.Category) {
    self.category = category
    self.products = Product.mockedByCategory[category] ?? []
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layout()
    makeDataSource()

    var snapshot = NSDiffableDataSourceSnapshot<Int, Product>()
    snapshot.appendSections([0])
    snapshot.appendItems(products, toSection: 0)
    self.dataSource.apply(snapshot)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let indexPath = collectionView.indexPathsForSelectedItems?.first {
      collectionView.deselectItem(at: indexPath, animated: true)
    }
  }
}

// MARK: - Layout

private extension ProductsViewController {
  func layout() {
    title = self.category.title
    view.backgroundColor = .white
    
    view.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    ProductCollectionViewCell.register(collectionView: collectionView)
  }
  
  func makeDataSource() {
    dataSource = UICollectionViewDiffableDataSource(
      collectionView: collectionView
    ) { [weak self] collectionView, indexPath, product in
      guard let self else { return nil }
      
      let data = self.dataSource.snapshot()
      let section = data.sectionIdentifiers[indexPath.section]
      
      switch section {
      case 0:
        let cell = ProductCollectionViewCell.cell(forCollection: collectionView, indexPath: indexPath)
        cell.configure(with: product)
        
        return cell
        
      default:
        return nil
      }
    }
  }
  
  func makeCollectionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.45),
      heightDimension: .fractionalHeight(1)
    )
    
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .absolute(250)
    )
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item, item]
    )
    group.interItemSpacing = .fixed(16)
    
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    
    return layout
  }
}

// MARK: - UICollectionViewDelegate

extension ProductsViewController {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let product = products[indexPath.item]
    
    coordinator?.showProduct(product)
  }
}
