import XCTest
@testable import Inkredible_Retail_UIKit

final class DeeplinkManagerTests: XCTestCase {
  func testRouteToProduct() {
    let routes: [String] = [
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens",
       
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens/",
       
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/dress-suits",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/coats-jackets",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/blazers-suit-jackets",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/tops-tees",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/ties",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens/jeans",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens/skirts-skorts",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens/dresses",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens/sweaters",
       
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/dress-suits/",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/coats-jackets/",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/blazers-suit-jackets/",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/tops-tees/",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/mens/ties/",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens/jeans/",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens/skirts-skorts/",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens/dresses/",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/category/womens/sweaters/",
       
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/product/c1569952",
       "ink-retail-uikit://movableink-inkredible-retail.herokuapp.com/product/c1569952/"
    ]

    for route in routes {
      let url = URL(string: route)!
      let result = DeeplinkManager.route(to: url)
      
      XCTAssertTrue(result)
    }
  }
}
