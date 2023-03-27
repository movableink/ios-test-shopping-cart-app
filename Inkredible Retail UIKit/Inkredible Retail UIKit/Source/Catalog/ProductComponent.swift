import UIKit

protocol ProductConfigurable {
  func configure(with product: Product)
}

final class ProductComponent: Component<StackedImageWithTextLayout>, ProductConfigurable {
  func configure(with product: Product) {
    self.layout.imageView.image = product.image
    self.layout.titleLabel.text = product.name
  }
}

final class ProductCollectionViewCell: CollectionViewComponent<StackedImageWithTextLayout>, ProductConfigurable {
  func configure(with product: Product) {
    self.layout.imageView.image = product.image
    self.layout.imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    self.layout.titleLabel.text = product.name
    
    let highlight = UIView(frame: bounds)
    highlight.backgroundColor = UIColor.lightGray
    self.selectedBackgroundView = highlight
  }
}
