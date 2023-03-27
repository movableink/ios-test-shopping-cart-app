import UIKit

final class StackedImageWithTextLayout: ComponentLayout {
  lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFit
    
    return view
  }()

  lazy var titleLabel: UILabel = {
    let view = UILabel()
    view.textColor = .darkText
    view.numberOfLines = 0
    view.lineBreakMode = .byWordWrapping
    view.textAlignment = .center
    
    return view
  }()
  
  lazy var stackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [imageView, titleLabel])
    view.axis = .vertical
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  func layout(on view: UIView) {
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
