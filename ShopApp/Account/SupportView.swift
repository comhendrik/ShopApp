//
//  SupportView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.03.22.
//

import SwiftUI

struct SupportView: View {
    let order: Order
    @StateObject var spm = SupportViewModel()
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Support:")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("for order: \(order.id)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            
            HStack {
                Text("For which article is support needed:")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            Spacer()
            
            ScrollView(showsIndicators: false) {
                ForEach(order.items) { orderItem in
                    SupportViewItemSelection(orderItem: orderItem, selectedItemID: $spm.itemID)
                    Divider()
                }
                .padding()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Select Support Case:")
                        .fontWeight(.bold)
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(SupportCases.allCases , id: \.self) { supportCase in
                            Button(action: {
                                spm.supportCase = supportCase
                            }, label: {
                                Text("\(supportCase.stringDescription)")
                                    .foregroundColor(spm.supportCase == supportCase ? .black : .gray)
                            })
                                .padding(5)
                                .background(Color.gray.opacity(0.05).cornerRadius(25))
                        }
                    }
                    
                    TextField("supportMessage", text: $spm.supportMessage)
                        .padding()
                    
                    
                    
                }
                .padding()
                
                
                
                Spacer()
            }
            
            Button(action: {
                spm.createSupportRequest(idOfOrder: order.id)
            }, label: {
                Text("Create request")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.black)
                    .cornerRadius(15, antialiased: false)
            })
                .alert(spm.alertMsg, isPresented: $spm.alert) {
                    Button("OK", role: .cancel) { }
                }

        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView(order: Order(price: 129.99, items: [OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "asdf", _price: 129.99), OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "asdfasdf", _price: 129.99), OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "ffff", _price: 129.99), OrderItem(_item: previewItem, _size: 45, _amount: 1, _id: "sss", _price: 129.99)], orderDate: Date.now, id: "gsgadsg"))
    }
}

struct SupportViewItemSelection: View {
    let orderItem: OrderItem
    @Binding var selectedItemID: String
    var body: some View {
        HStack {
            Button(action: {
                selectedItemID = orderItem.id
            }, label: {
                Image(systemName: orderItem.id == selectedItemID ? "circle.inset.filled" : "circle")
                    .foregroundColor(orderItem.id == selectedItemID ? .black : .gray)
            })
            Spacer()
            VStack(alignment: .leading) {
                Text(orderItem.item.title)
                    .fontWeight(.bold)
                Text("size: \(orderItem.size)")
                    .font(.subheadline)
                Text("amount: \(orderItem.amount)")
                    .font(.subheadline)
                Text(orderItem.id)
                    .fontWeight(.light)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            Spacer()
            ZStack {
                Color.gray.opacity(0.05)
                AsyncImage(url: URL(string: orderItem.item.imagePath)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        }
    }
}
