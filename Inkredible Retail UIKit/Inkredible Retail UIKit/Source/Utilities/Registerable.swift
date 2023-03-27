import UIKit

/// Protocol to register and load TableView and CollectionView cells.
protocol Registerable {
  /// The cell identifier. Defaults to the class name.
  static var identifier: String { get }
}

extension Registerable {
  static var identifier: String { return String(describing: Self.self) }
}

extension Registerable where Self: UITableViewCell {
  /**
   Registers a cell with a TableView.
   
   ```
   MyTableViewCell.register(tableView: tableView)
   ```
   
   - Parameter tableView: The TableView to register the cell to.
   */
  static func register(tableView: UITableView) {
    tableView.register(Self.self, forCellReuseIdentifier: identifier)
  }
  
  /**
   Dequeues a reusable cell.
   
   ```
   MyTableViewCell.cell(forTable: tableView)
   ```
   
   - Parameter table: The TableView to dequeue the cell from.
   
   - Returns: A dequeued cell
   */
  static func cell(forTable table: UITableView) -> Self {
    // swiftlint:disable:next force_cast
    table.dequeueReusableCell(withIdentifier: self.identifier) as! Self
  }
  
  /**
   Dequeues a reusable cell.
   
   ```
   MyTableViewCell.cell(forTable: tableView, indexPath: indexPath)
   ```
   
   - Parameter table: The TableView to dequeue the cell from.
   - Parameter indexPath: The indexPath of the cell.
   
   - Returns: A dequeued cell
   */
  static func cell(forTable table: UITableView, indexPath: IndexPath) -> Self {
    // swiftlint:disable:next force_cast
    table.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! Self
  }
}

extension Registerable where Self: UICollectionViewCell {
  /**
   Registers a cell with a CollectionView.
   
   ```
   MyCollectionViewCell.register(collectionView: collectionView)
   ```
   
   - Parameter collectionView: The CollectionView to register the cell to.
   */
  static func register(collectionView: UICollectionView) {
    collectionView.register(Self.self, forCellWithReuseIdentifier: identifier)
  }
  
  /**
   Dequeues a reusable cell.
   
   ```
   MyCollectionViewCell.cell(forCollection: collectionView, indexPath: indexPath)
   ```
   
   - Parameter collectionView: The CollectionView to dequeue the cell from.
   - Parameter indexPath: The indexPath of the cell.
   
   - Returns: A dequeued cell
   */
  static func cell(forCollection collectionView: UICollectionView, indexPath: IndexPath) -> Self {
    collectionView.dequeueReusableCell(
      withReuseIdentifier: self.identifier,
      for: indexPath
      // swiftlint:disable:next force_cast
    ) as! Self
  }
}

extension Registerable where Self: UICollectionReusableView {
  /// Registers a UICollectionReusableView with a UICollectionView.
  ///
  /// - Parameters:
  ///   - collectionView: The CollectionView to register the view to.
  ///   - kind: The kind of supplementary view to create. This value is defined by the layout object.
  static func register(collectionView: UICollectionView, forSupplementaryViewOfKind kind: String) {
    collectionView.register(
      self,
      forSupplementaryViewOfKind: kind,
      withReuseIdentifier: identifier
    )
  }
  
  /// Dequeues a reusable supplementary view.
  ///
  /// - Parameters:
  ///   - kind: The kind of supplementary view to retrieve. This value is defined by the layout object.
  ///   - collectionView: The collection view this view was registered with.
  ///   - indexPath: The index path specifying the location of the supplementary view in the collection view.
  ///                The data source receives this information when it is asked for the view and should just pass it along.
  ///                This method uses the information to perform additional configuration based on the view’s position in
  ///                the collection view.
  static func view(forSupplementaryViewOfKind kind: String, inCollection collectionView: UICollectionView, indexPath: IndexPath) -> Self {
    collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: identifier,
      for: indexPath
      // swiftlint:disable:next force_cast
    ) as! Self
  }
}
