//
//  CartItemsListView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct FavoriteItemsListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteItem.title, ascending: true)],
        animation: .default)
    private var items: FetchedResults<FavoriteItem>
    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.title!)
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(managedObjectContext.delete)
            PersistenceController.shared.save()
        }
    }
}

struct CartItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteItemsListView()
    }
}
