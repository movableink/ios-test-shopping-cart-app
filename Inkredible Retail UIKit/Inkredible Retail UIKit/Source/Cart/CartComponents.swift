import UIKit

final class CartListItemLayout: ComponentLayout {
  let stackLayout = Component<StackedImageWithTextListLayout>()
  let quantityLayout = Component<QuantityLayout>()
  
  var imageView: UIImageView {
    stackLayout.layout.imageView
  }
  
  var titleLabel: UILabel {
    stackLayout.layout.titleLabel
  }
  
  var subtitleLabel: UILabel {
    stackLayout.layout.subtitleLabel
  }
  
  var quantity: Int {
    get { quantityLayout.layout.quantity }
    set { quantityLayout.layout.quantity = newValue }
  }
  
  private lazy var container: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  func layout(on view: UIView) {
    view.addSubview(container)
    stackLayout.layout.layout(on: container)
    stackLayout.layout.stackView.addArrangedSubview(quantityLayout)
    
    NSLayoutConstraint.activate([
      container.topAnchor.constraint(equalTo: view.topAnchor),
      container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}

final class CartListItemTableViewCell: TableViewComponent<CartListItemLayout> {
  private var product: Product?
  
  private var upAction: UIAction {
    let action = UIAction(identifier: .init(rawValue: "upAction")) { [product] _ in
      guard let product else { return }
      Cart.shared.add(product: product)
    }
    
    return action
  }
  
  private var downAction: UIAction {
    let action = UIAction(identifier: .init(rawValue: "downAction")) { [product] _ in
      guard let product else { return }
      Cart.shared.decrementQuantity(of: product)
    }
    
    return action
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.product = nil
    self.layout.quantityLayout.layout.up.removeAction(upAction, for: .touchUpInside)
    self.layout.quantityLayout.layout.down.removeAction(downAction, for: .touchUpInside)
  }
  
  func configure(with product: Product, quantity: Int) {
    self.product = product
    
    self.layout.imageView.image = product.image
    self.layout.titleLabel.textAlignment = .natural
    self.layout.titleLabel.text = product.name
    self.layout.subtitleLabel.text = product.formattedPrice
    
    self.layout.imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    self.layout.imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    
    self.layout.quantity = quantity
    self.layout.quantityLayout.layout.up.addAction(upAction, for: .touchUpInside)
    self.layout.quantityLayout.layout.down.addAction(downAction, for: .touchUpInside)
  }
}
