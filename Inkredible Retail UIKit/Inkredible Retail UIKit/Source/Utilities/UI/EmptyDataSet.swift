import UIKit

/// A component for an empty data set.
///
/// You should setup constraints like so:
///
/// ```
/// emptyDataSet.leadingAnchor.constraint(equalTo: view.leadingAnchor)
/// emptyDataSet.trailingAnchor.constraint(equalTo: view.trailingAnchor)
/// emptyDataSet.centerYAnchor.constraint(equalTo: view.centerYAnchor)
/// ```
typealias EmptyDataSet = Component<EmptyDataSetLayout>

extension EmptyDataSet {
  typealias Configuration = EmptyDataSetLayout.Configuration
  
  static func make(with config: EmptyDataSetLayout.Configuration) -> EmptyDataSet {
    let view = EmptyDataSet()
    view.layout.update(config: config)
    
    return view
  }
}

final class EmptyDataSetLayout: ComponentLayout {
  struct Configuration {
    let image: UIImage?
    let title: String?
    let subtitle: String?
    let actionText: String?
    let actionTapped: (() -> Void)?
    
    fileprivate var isLoading: Bool = false
    
    static func makeLoading() -> Configuration {
      var config = Configuration(image: nil, title: nil, subtitle: nil, actionText: nil)
      config.isLoading = true
      
      return config
    }
    
    /// Creates a Configuration for an EmptyDataSet. Everything defaults to nil.
    init(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil, actionText: String? = nil, actionTapped: (() -> Void)? = nil) {
      self.image = image
      self.title = title
      self.subtitle = subtitle
      self.actionText = actionText
      self.actionTapped = actionTapped
    }
  }
  
  private lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }()
  
  private lazy var titleLabel: UILabel = {
    let view = UILabel()
    view.font = .systemFont(ofSize: 16)
    view.textColor = UIColor.systemGray
    view.textAlignment = .center
    view.numberOfLines = 0
    
    return view
  }()
  
  private lazy var subtitleLabel: UILabel = {
    let view = UILabel()
    view.font = .systemFont(ofSize: 14)
    view.textColor = UIColor.systemGray2
    view.textAlignment = .center
    view.numberOfLines = 0
    
    return view
  }()
  
  private lazy var button: UIButton = {
    var config = UIButton.Configuration.tinted()
    config.title = self.config?.actionText ?? ""
    config.baseForegroundColor = .white
    config.background.backgroundColor = .systemBlue
    config.cornerStyle = .medium
    
    let view = UIButton(
      configuration: config,
      primaryAction: .init(
        handler: { [weak self] _ in
          guard let self else { return }
          self.config?.actionTapped?()
        }
      )
    )
//    view.configuration = config
//    view.setNeedsUpdateConfiguration()
    
    return view
  }()
  
  private lazy var loadingIndicator: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .large)
    view.isHidden = true
    view.startAnimating()

    return view
  }()
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView(
      arrangedSubviews: [
        imageView, titleLabel, subtitleLabel,
        button, loadingIndicator
      ]
    )
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.alignment = .center
    view.distribution = .equalSpacing
    view.spacing = 20
    
    return view
  }()
  
  private var config: Configuration?
  
  func layout(on view: UIView) {
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 50),
      titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -50),
      
      subtitleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 66),
      subtitleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -66),
      
      button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
      button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
    ])
  }
  
  func update(config: Configuration) {
    self.config = config

    imageView.image = config.image
    titleLabel.text = config.title
    subtitleLabel.text = config.subtitle
    button.setTitle(config.actionText, for: .normal)
    
    imageView.isHidden = config.image == nil
    titleLabel.isHidden = config.title == nil
    subtitleLabel.isHidden = config.subtitle == nil
    button.isHidden = config.actionText == nil
    loadingIndicator.isHidden = !config.isLoading
  }
}
