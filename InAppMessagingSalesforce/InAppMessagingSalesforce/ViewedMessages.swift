import Foundation
import SwiftData

@Model
final class ViewedMessage {
  #Index<ViewedMessage>([\.id])
  @Attribute(.unique) private(set) var id: String
  
  init(id: String) {
    self.id = id
  }
}

final class ViewedMessagesStore {
  let container: ModelContainer
  
  init() throws {
    container = try ModelContainer(for: ViewedMessage.self)
  }
  
  func create(_ message: ViewedMessage) throws {
    let context = ModelContext(container)
    context.insert(message)
    try context.save()
  }
  
  func all() throws -> [ViewedMessage] {
    let context = ModelContext(container)
    let fetchDescriptor = FetchDescriptor<ViewedMessage>()
    return try context.fetch(fetchDescriptor)
  }
  
  func find(id: String) throws -> ViewedMessage? {
    let context = ModelContext(container)
    var fetchDescriptor = FetchDescriptor<ViewedMessage>(
      predicate: #Predicate { $0.id == id }
    )
    fetchDescriptor.fetchLimit = 1
    
    return try context.fetch(fetchDescriptor).first
  }
  
  func view(id: String?) {
    guard let id else { return }
    
    try? create(.init(id: id))
  }
  
  /// Returns True if the message has been seen before, otherwise False
  func hasSeen(id: String) throws -> Bool {
    let message = try find(id: id)
    return message != nil
  }
  
  /// Decide if the message should be shown or not
  func canView(id: String?) -> Bool {
    do {
      // Check if there's a message ID and if it's been seen before
      if let id {
        return try !hasSeen(id: id)
      }
      else {
        // If there isn't a messageID, decide if you should show it or not.
        // In this case, we're fine showing it, so we'll do nothing.
        return true
      }
    }
    catch {
      // If an error is thrown by the store, decide what to do.
      // In this case, we're fine showing it, so we'll do nothing.
      return true
    }
  }
}
