import UIKit

final class StackedImageWithTextListLayout: ComponentLayout {
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
    view.font = .systemFont(ofSize: 18)
    
    return view
  }()
  
  lazy var subtitleLabel: UILabel = {
    let view = UILabel()
    view.textColor = .systemGray
    view.numberOfLines = 0
    view.lineBreakMode = .byWordWrapping
    view.textAlignment = .center
    view.font = .systemFont(ofSize: 14)
    
    return view
  }()
  
  private lazy var vStack: UIStackView = {
    let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    view.axis = .vertical
    view.alignment = .leading
    
    return view
  }()
  
  lazy var stackView: UIStackView = {
    let spacer = UIView()
    spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    let view = UIStackView(arrangedSubviews: [imageView, vStack, spacer])
    view.axis = .horizontal
    view.distribution = .fill
    view.alignment = .center
    view.spacing = 10
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
