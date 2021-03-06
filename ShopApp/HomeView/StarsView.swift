//
//  StarsView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 01.12.21.
//

import SwiftUI
//Diese View stellt das Rating in 0-5 Sternen dar.
//Der Code stammt von dieser Website: https://swiftuirecipes.com/blog/star-rating-view-in-swiftui und ich habe ihn kopiert, da ich selbst überzeugt von dieser Lösung bin.
struct StarsView: View {
  private static let MAX_RATING: Float = 5

  let rating: Float
  private let fullCount: Int
  private let emptyCount: Int
  private let halfFullCount: Int

  init(rating: Float) {
    self.rating = rating
    fullCount = Int(rating)
    emptyCount = Int(StarsView.MAX_RATING - rating)
    halfFullCount = (Float(fullCount + emptyCount) < StarsView.MAX_RATING) ? 1 : 0
  }

  var body: some View {
    HStack {
      ForEach(0..<fullCount) { _ in
         self.fullStar
              .font(.title3)
       }
       ForEach(0..<halfFullCount) { _ in
         self.halfFullStar
               .font(.title2)
       }
       ForEach(0..<emptyCount) { _ in
         self.emptyStar
               .font(.title2)
       }
     }
  }

  private var fullStar: some View {
      Image(systemName: "star.fill").foregroundColor(.black)
  }

  private var halfFullStar: some View {
      Image(systemName: "star.leadinghalf.fill").foregroundColor(.black)
  }

  private var emptyStar: some View {
      Image(systemName: "star").foregroundColor(.black)
  }
}

struct StarsView_Previews: PreviewProvider {
    static var previews: some View {
        StarsView(rating: 2.5)
    }
}
