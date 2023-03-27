//
//  Product.swift
//  Inkredible Retail
//
//  Created by Movable Ink on 8/1/22.
//

import Foundation

struct Product: Identifiable, Hashable {
  enum Category: String, CaseIterable {
    // men's
    case jackets
    case shirts
    case dressSuit
    case suitJackets
    case ties
    
    // women's
    case dresses
    case skirts
    case jeans
    case sweaters
    
    var title: String {
      switch self {
      case .jackets:
        return "Coats & Jackets"
      case .shirts:
        return "Tops & Tees"
      case .dressSuit:
        return "Dress Suits"
      case .suitJackets:
        return "Blazers & Suit Jackets"
      case .ties:
        return "Ties"
      case .dresses:
        return "Dresses"
      case .skirts:
        return "Shirts & Skorts"
      case .jeans:
        return "Jeans"
      case .sweaters:
        return "Sweaters"
      }
    }
    
    var url: URL {
      switch self {
      case .jackets:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/mens/coats-jackets")!
      case .shirts:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/mens/tops-tees")!
      case .dressSuit:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/mens/dress-suits")!
      case .suitJackets:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/mens/blazers-suit-jackets")!
      case .ties:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/mens/ties")!
      case .dresses:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/womens/dresses")!
      case .skirts:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/womens/skirts-skorts")!
      case .jeans:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/womens/jeans")!
      case .sweaters:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/categor/womens/sweaters")!
      }
    }
    
    static func from(deeplinkID: String) -> Category? {
      switch deeplinkID {
      case "dress-suits": return .dressSuit
      case "coats-jackets": return .jackets
      case "blazers-suit-jackets": return .suitJackets
      case "tops-tees": return .shirts
      case "ties": return .ties
      case "jeans": return .jeans
      case "skirts-skorts": return .skirts
      case "dresses": return .dresses
      case "sweaters": return .sweaters
      
      default: return nil
      }
    }
  }
  
  enum Gender: String, Hashable, CaseIterable {
    case men
    case women
    
    var title: String {
      switch self {
      case .men: return "Men's"
      case .women: return "Women's"
      }
    }
    
    var url: URL {
      switch self {
      case .men:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/mens")!
        
      case .women:
        return URL(string: "https://movableink-inkredible-retail.herokuapp.com/category/womens")!
      }
    }
    
    static func from(deeplinkID: String) -> Gender? {
      switch deeplinkID {
      case "men", "mens": return .men
      case "women", "womens": return .women
      default: return nil
      }
    }
  }

  static let mockedByGender = Dictionary(grouping: mock, by: \.gender)
  static let mockedByCategory = Dictionary(grouping: mock, by: \.category)
  
  let id: String
  let name: String
  let imageName: String
  let price: Int
  let gender: Gender
  let category: Category
  
  var url: URL {
    URL(string: "https://movableink-inkredible-retail.herokuapp.com/product/\(id)")!
  }
  
  private(set) var formattedPrice: String
  
  init(id: String, imageName: String, price: Int, name: String, gender: Gender, category: Category) {
    self.id = id
    self.imageName = imageName
    self.price = price
    self.name = name
    self.gender = gender
    self.category = category
    
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .currency
    
    self.formattedPrice = formatter.string(from: (price / 100) as NSNumber) ?? ""
  }
  
  /// Returns all the categories that are available for a given gender
  static func categoriesForGender(_ gender: Gender) -> [Category] {
    Array(Set(mockedByGender[gender]!.map { $0.category }))
  }
  
  static let mock = [
    Product(
      id: "118561",
      imageName: "118561_ALT-1000",
      price: 4450,
      name: "Women's Levi's® 505™ Straight Jeans",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "1695762",
      imageName: "1695762_ALT-1000",
      price: 4000,
      name: "Women's Gloria Vanderbilt Amanda Classic Tapered Jeans",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "1731442",
      imageName: "1731442_ALT-1000",
      price: 4400,
      name: "Women's Plus Size Gloria Vanderbilt Amanda Classic Tapered Jeans",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "1833330",
      imageName: "1833330_ALT-1000",
      price: 17900,
      name: "Men's Jean-Paul Germain Classic-Fit Microsuede Blazer",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "1878818",
      imageName: "1878818_ALT-1000",
      price: 4500,
      name: "Women's Lee Modern Fit Curvy Bootcut Jeans",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "2263298",
      imageName: "2263298_ALT-1000",
      price: 4000,
      name: "Women's Lee Relaxed Fit Straight Leg Jeans",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "2375187",
      imageName: "2375187_ALT-1000",
      price: 4200,
      name: "Women's Simply Vera Vera Wang Rivet Denim Leggings",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "2403210",
      imageName: "2403210_ALT-1000",
      price: 22000,
      name: "Men's Chaps Performance Classic-Fit Wool-Blend Comfort Stretch Suit Jacket",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "2426788",
      imageName: "2426788_ALT-1000",
      price: 30000,
      name: "Men's Apt. 9® Slim-Fit Unhemmed Suit",
      gender: .men,
      category: .dressSuit
    ),
    Product(
      id: "2439667",
      imageName: "2439667_ALT-1000",
      price: 22000,
      name: "Men's Chaps Classic-Fit Wool-Blend Performance Suit Jacket",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "2447810",
      imageName: "2447810_ALT-1000",
      price: 30000,
      name: "Men's Croft & Barrow Classic-Fit Unhemmed Suit",
      gender: .men,
      category: .dressSuit
    ),
    Product(
      id: "2467840",
      imageName: "2467840_ALT-1000",
      price: 3600,
      name: "Women's Briggs Comfort Waistband A-Line Skirt",
      gender: .women,
      category: .skirts
    ),
    Product(
      id: "2480979",
      imageName: "2480979_ALT-1000",
      price: 24000,
      name: "Men's Marc Anthony Slim-Fit Stretch Suit Jacket",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "2481364",
      imageName: "2481364_Navy_Romance-1000",
      price: 3000,
      name: "Women's Tek Gear® Knit Workout Skort",
      gender: .women,
      category: .skirts
    ),
    Product(
      id: "2516619",
      imageName: "2516619_Berry-1000",
      price: 3400,
      name: "Men's Croft & Barrow® Patterned Tie",
      gender: .men,
      category: .ties
    ),
    Product(
      id: "2527130",
      imageName: "2527130_ALT-1000",
      price: 22000,
      name: "Men's Van Heusen Flex Slim-Fit Suit Jacket",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "2591560",
      imageName: "2591560_ALT-1000",
      price: 7498,
      name: "Women's Chaps Pleated Sheath Dress",
      gender: .women,
      category: .dresses
    ),
    Product(
      id: "2599191",
      imageName: "2599191_ALT-1000",
      price: 6000,
      name: "Men's Columbia Flattop Ridge Fleece Jacket",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "2608418",
      imageName: "2608418_ALT-1000",
      price: 12999,
      name: "Men's Columbia Rockaway Mountain Interchange Systems Jacket",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "2694388",
      imageName: "2694388_ALT-1000",
      price: 13499,
      name: "Men's Towne Wool-Blend Double-Breasted Peacoat with Plaid Scarf",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "2728436",
      imageName: "2728436_ALT-1000",
      price: 22000,
      name: "Men's J.M. Haggar Premium Slim-Fit Stretch Suit Coat",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "2753275",
      imageName: "2753275_ALT-1000",
      price: 3699,
      name: "Women's White Mark Solid Midi Skirt",
      gender: .women,
      category: .skirts
    ),
    Product(
      id: "2783785",
      imageName: "2783785_ALT-1000",
      price: 18000,
      name: "Men's Apt. 9<sup>®</sup> Premier Flex Slim-Fit Suit Coat",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "2852223",
      imageName: "2852223_ALT-1000",
      price: 8999,
      name: "Men's Columbia Wister Slope Colorblock Thermal Coil Insulated Jacket",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "2871342",
      imageName: "2871342_ALT-1000",
      price: 3999,
      name: "Men's ZeroXposur Rocker Softshell Jacket",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "2874625",
      imageName: "2874625_Granite_Heather-1000",
      price: 3500,
      name: "Men's Champion Fleece Powerblend Top",
      gender: .men,
      category: .shirts
    ),
    Product(
      id: "2877645",
      imageName: "2877645_ALT-1000",
      price: 9999,
      name: "Men's Columbia Rapid Excursion Thermal Coil Puffer Jacket",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "2881280",
      imageName: "2881280_ALT-1000",
      price: 3500,
      name: "Women's Apt. 9® Embellished Bootcut Jeans",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "2898455",
      imageName: "2898455_ALT-1000",
      price: 4999,
      name: "Men's Heat Keep Nano Modern-Fit Packable Puffer Jacket",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "2900935",
      imageName: "2900935_Buffalo_Gray-1000",
      price: 1998,
      name: "Men's Urban Pipeline® Awesomely Soft Ultimate Plaid Flannel Shirt",
      gender: .men,
      category: .shirts
    ),
    Product(
      id: "2939320",
      imageName: "2939320_ALT-1000",
      price: 9399,
      name: "Men's Andrew Marc Wool-Blend Peacoat",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "2957101",
      imageName: "2957101_ALT6-1000",
      price: 1499,
      name: "Men's Croft & Barrow® Classic-Fit Easy-Care Henley",
      gender: .men,
      category: .shirts
    ),
    Product(
      id: "2957114",
      imageName: "2957114_New_White-1000",
      price: 1698,
      name: "Men's Croft & Barrow® Classic-Fit Easy-Care Interlock Polo",
      gender: .men,
      category: .shirts
    ),
    Product(
      id: "2959247",
      imageName: "2959247_Blue_Ombre_Plaid-1000",
      price: 1499,
      name: "Men's Croft & Barrow® True Comfort Plaid Classic-Fit Flannel Button-Down Shirt",
      gender: .men,
      category: .shirts
    ),
    Product(
      id: "2962920",
      imageName: "2962920_ALT-1000",
      price: 5000,
      name: "Women's Simply Vera Vera Wang Skinny Jeans",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "2964013",
      imageName: "2964013_ALT-1000",
      price: 3199,
      name: "LC Lauren Conrad Runway Collection Pleated Velvet Skirt - Women's",
      gender: .women,
      category: .skirts
    ),
    Product(
      id: "2964826",
      imageName: "2964826_ALT-1000",
      price: 2499,
      name: "Women's Apt. 9® Tummy Control Pull-On Pencil Skirt",
      gender: .women,
      category: .skirts
    ),
    Product(
      id: "2971290",
      imageName: "2971290_ALT-1000",
      price: 6400,
      name: "Men's Chaps Classic-Fit Corduroy Stretch Sport Coat",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "2972771",
      imageName: "2972771_ALT-1000",
      price: 6400,
      name: "Men's Van Heusen Flex Slim-Fit Sport Coat",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "2980246",
      imageName: "2980246_Red_Large_Check-1000",
      price: 1499,
      name: "Men's Croft & Barrow® Arctic Fleece Quarter-Zip Pullover",
      gender: .men,
      category: .shirts
    ),
    Product(
      id: "2982007",
      imageName: "2982007_ALT-1000",
      price: 4000,
      name: "Women's Wallflower Luscious Curvy Bootcut Jeans",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "2984389",
      imageName: "2984389_ALT-1000",
      price: 4000,
      name: "Women's Tek Gear® Hooded Long Sleeve Dress",
      gender: .women,
      category: .dresses
    ),
    Product(
      id: "2995056",
      imageName: "2995056_ALT-1000",
      price: 1499,
      name: "Women's Croft & Barrow® Essential Ribbed Turtleneck Sweater",
      gender: .women,
      category: .sweaters
    ),
    Product(
      id: "2999682",
      imageName: "2999682_ALT-1000",
      price: 2499,
      name: "Women's Apt. 9® Cozy Shawl Collar Cardigan",
      gender: .women,
      category: .sweaters
    ),
    Product(
      id: "3003041",
      imageName: "3003041_ALT-1000",
      price: 2999,
      name: "Women's Apt. 9® Fit & Flare Dress",
      gender: .women,
      category: .dresses
    ),
    Product(
      id: "3009587",
      imageName: "3009587_ALT-1000",
      price: 3699,
      name: "Men's New Balance Sherpa-Lined Polar Fleece Hooded Jacket",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "3021766",
      imageName: "3021766_ALT-1000",
      price: 1499,
      name: "Women's SONOMA Goods for Life™ Lattice Sweater",
      gender: .women,
      category: .sweaters
    ),
    Product(
      id: "3024658",
      imageName: "3024658_ALT-1000",
      price: 9999,
      name: "Men's Free Country 3-in-1 Systems Jacket",
      gender: .men,
      category: .jackets
    ),
    Product(
      id: "3028158",
      imageName: "3028158_ALT-1000",
      price: 2499,
      name: "Women's Apt. 9® Lace Yoke A-Line Dress",
      gender: .women,
      category: .dresses
    ),
    Product(
      id: "3036618",
      imageName: "3036618_Sweet_Lavender-1000",
      price: 1199,
      name: "Big & Tall Croft & Barrow® Classic-Fit Easy-Care Interlock Polo",
      gender: .men,
      category: .shirts
    ),
    Product(
      id: "3040746",
      imageName: "3040746_Camo_ALT-1000",
      price: 8800,
      name: "Women's Rock & Republic® Fever Denim Rx™ Pull-On Jean Leggings",
      gender: .women,
      category: .jeans
    ),
    Product(
      id: "3054934",
      imageName: "3054934_ALT-1000",
      price: 3899,
      name: "Chaps Women's Metallic Faux-Suede Pleated Midi Skirt",
      gender: .women,
      category: .skirts
    ),
    Product(
      id: "3057086",
      imageName: "3057086_ALT-1000",
      price: 3200,
      name: "Women's Dana Buchman Mitered Cowlneck Sweater Dress",
      gender: .women,
      category: .dresses
    ),
    Product(
      id: "3063706",
      imageName: "3063706_ALT-1000",
      price: 8199,
      name: "Women's Chaps Satin Trim Jersey Dress",
      gender: .women,
      category: .dresses
    ),
    Product(
      id: "567950",
      imageName: "567950_ALT-1000",
      price: 7998,
      name: "Men's Croft & Barrow® True Comfort Classic-Fit Sport Coat",
      gender: .men,
      category: .suitJackets
    ),
    Product(
      id: "825463",
      imageName: "825463_Soho_Gray-1000",
      price: 3200,
      name: "Men's Croft & Barrow® Classic-Fit Easy Care Point-Collar Dress Shirt",
      gender: .men,
      category: .shirts
    ),
    Product(
      id: "c1193954",
      imageName: "c1193954-1000",
      price: 15000,
      name: "Men's Haggar Travel Tailored-Fit Performance Suit Separates",
      gender: .men,
      category: .dressSuit
    ),
    Product(
      id: "c1193957",
      imageName: "c1193957-1000",
      price: 14500,
      name: "Men's Marc Anthony Slim-Fit Stretch Suit Separates",
      gender: .men,
      category: .dressSuit
    ),
    Product(
      id: "c1569952",
      imageName: "c1569952-1000",
      price: 14000,
      name: "Men's Apt. 9® Premier Flex Extra-Slim Fit Suit Separates",
      gender: .men,
      category: .dressSuit
    ),
    Product(
      id: "c1621950",
      imageName: "c1621950-1000",
      price: 18000,
      name: "Men's J.M. Haggar Premium Slim-Fit Stretch Suit Separates",
      gender: .men,
      category: .dressSuit
    ),
    Product(
      id: "c1672950",
      imageName: "c1672950-1000",
      price: 13000,
      name: "Men's Apt. 9® Slim-Fit Stretch Suit Separates",
      gender: .men,
      category: .dressSuit
    ),
    Product(
      id: "c1672951",
      imageName: "c1672951-1000",
      price: 13500,
      name: "Men's Apt. 9® Extra-Slim Fit Stretch Suit Separates",
      gender: .men,
      category: .dressSuit
    ),
    Product(
      id: "c890950",
      imageName: "c890950-1000",
      price: 15999,
      name: "Men's Chaps Performance Classic-Fit Wool-Blend Stretch Suit Separates",
      gender: .men,
      category: .dressSuit
    )
  ]
}
