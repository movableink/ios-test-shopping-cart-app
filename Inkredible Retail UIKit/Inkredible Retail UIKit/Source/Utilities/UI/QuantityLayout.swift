import UIKit

final class QuantityLayout: ComponentLayout {
  lazy var up: UIButton = {
    let view = UIButton()
    let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
    let image = UIImage(systemName: "chevron.up", withConfiguration: config)
    
    view.setImage(image, for: .normal)
    view.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    return view
  }()
  
  lazy var label: UILabel = {
    let view = UILabel()
    view.font = .systemFont(ofSize: 20)
    view.textColor = .systemGray
    view.textAlignment = .center
    view.text = "1"
    
    return view
  }()
  
  lazy var down: UIButton = {
    let view = UIButton()
    let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
    let image = UIImage(systemName: "chevron.down", withConfiguration: config)
    
    view.setImage(image, for: .normal)
    view.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    return view
  }()
  
  lazy var stackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [up, label, down])
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    
    return view
  }()
  
  var quantity: Int = 1 {
    didSet {
      label.text = quantity.formatted()
      
      down.isEnabled = quantity > 1
    }
  }
  
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
