import UIKit

final class ProductDetailsViewController: UIViewController {
  weak var coordinator: CatalogCoordinator?
  private let product: Product
  
  private lazy var productView: Component<StackedImageWithTextLayout> = {
    let view = Component<StackedImageWithTextLayout>()
    view.layout.titleLabel.text = product.name.capitalized
    view.layout.imageView.image = product.image
    view.layout.imageView.heightAnchor.constraint(equalToConstant: 175).isActive = true
    
    return view
  }()
  
  private lazy var button: UIButton = {
    var config = UIButton.Configuration.tinted()
    config.title = "Add to cart"
    config.baseForegroundColor = .white
    config.background.backgroundColor = .systemBlue
    config.cornerStyle = .medium
    
    let view = UIButton(
      configuration: config,
      primaryAction: .init(
        handler: { [product] _ in
          Cart.shared.add(product: product)
        }
      )
    )
    
    return view
  }()
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [productView, button])
    view.axis = .vertical
    view.distribution = .fillProportionally
    view.spacing = 15
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  init(product: Product) {
    self.product = product
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    layout()
  }
}

// MARK: - Layout

private extension ProductDetailsViewController {
  func layout() {
    title = product.name.capitalized
    view.backgroundColor = .white
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }
}
