import UIKit

final class StackedTextWithButtonLayout: ComponentLayout {
  lazy var titleLabel: UILabel = {
    let view = UILabel()
    view.textColor = .darkText
    view.numberOfLines = 0
    view.lineBreakMode = .byWordWrapping
    view.textAlignment = .center
    
    return view
  }()
  
  lazy var subtitleLabel: UILabel = {
    let view = UILabel()
    view.textColor = .darkText
    view.numberOfLines = 0
    view.lineBreakMode = .byWordWrapping
    view.textAlignment = .center
    
    return view
  }()
  
  lazy var button: UIButton = UIButton()
  
  lazy var stackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, button])
    view.axis = .vertical
    view.spacing = 8
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  func layout(on view: UIView) {
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
      button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
    ])

  }
  
  func update(buttonConfiguration: UIButton.Configuration? = nil, buttonAction: UIAction? = nil) {
    if let buttonConfiguration {
      button.configuration = buttonConfiguration
      button.setNeedsUpdateConfiguration()
    }
    
    if let buttonAction {
      button.addAction(buttonAction, for: .touchUpInside)
    }
  }
}
