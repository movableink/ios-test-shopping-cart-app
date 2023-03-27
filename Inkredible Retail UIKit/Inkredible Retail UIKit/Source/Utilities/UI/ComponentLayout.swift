import UIKit

/// A protocol to share components (view layouts) across different types.
protocol ComponentLayout {
  /// Called to layout a view onto another view as a subview.
  /// Ensure to call `view.addSubview(myView)` in this method.
  ///
  /// You should not call this method yourself unless you are creating a layout that utilizes other layouts.
  /// The `Component` type that is is configured with a layout will call
  /// this method for you.
  func layout(on view: UIView)
  init()
}

/// Generic UIView type that uses a ComponentLayout
class Component<Layout: ComponentLayout>: UIView {
  /// The layout that was used to create the component.
  let layout: Layout
  
  /// Creates a new Component.
  convenience init() {
    self.init(frame: .zero)
  }
  
  override init(frame: CGRect) {
    self.layout = Layout()
    super.init(frame: frame)
    layout.layout(on: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

/// Generic UITableViewCell type that uses a ComponentLayout
class TableViewComponent<Layout: ComponentLayout>: UITableViewCell, Registerable {
  /// The layout that was used to create the component.
  let layout: Layout
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.layout = Layout()
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    layout.layout(on: contentView)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

/// Generic UICollectionViewCell type that uses a ComponentLayout
class CollectionViewComponent<Layout: ComponentLayout>: UICollectionViewCell, Registerable {
  /// The layout that was used to create the component.
  let layout: Layout
  
  /// Creates a new Component.
  override init(frame: CGRect) {
    self.layout = Layout()
    super.init(frame: frame)
    layout.layout(on: contentView)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
