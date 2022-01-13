//
//  AccountView.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.12.21.
//

import SwiftUI

struct AccountView: View {
    @StateObject var uvm: UserViewModel
    @StateObject var lvm: LoginViewModel
    var body: some View {
        NavigationView {
            VStack {
                
                ZStack {
                    Color.gray.opacity(0.05)
                    AsyncImage(url: URL(string: uvm.mainUser.profilePicPath)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                        
                    } placeholder: {
                        ProgressView()
                    }
                }
                .clipShape(Circle())
                .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                
                VStack {
                    Text("\(uvm.mainUser.firstName) \(uvm.mainUser.lastName)")
                        .fontWeight(.bold)
                        .font(.title2)
                    Text("\(uvm.mainUser.memberStatus) Member")
                        .fontWeight(.bold)
                        .font(.subheadline)
                }
                .padding()
                HStack {
                    VStack {
                        Text("email:")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Text(uvm.mainUser.email)
                            .font(.subheadline)
                            .padding(.bottom)
                        Text("memberId:")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Text(uvm.mainUser.memberId)
                            .font(.subheadline)
                            .padding(.bottom)
                        Text("birthday:")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Text("\(uvm.mainUser.birthday.formatted(date: .numeric, time: .omitted))")
                            .font(.subheadline)
                            .padding(.bottom)
                        Text("address:")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Text("\(uvm.mainUser.adress.street) \(uvm.mainUser.adress.number) \(String(uvm.mainUser.adress.zipCode)) \(uvm.mainUser.adress.city)")
                            .font(.subheadline)
                            .padding(.bottom)
                        Text("land:")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Text(uvm.mainUser.adress.land)
                            .font(.subheadline)

                    }
                    .foregroundColor(.gray)
                    .padding()
                }
                
                
                
                NavigationLink(destination: {
                    ScrollView {
                        ForEach(uvm.orders) { order in
                            NavigationLink(destination: {
                                OrderOverviewView(order: order)
                            }, label: {
                                OrderMiniViewer(order: order)
                            })
                        }
                    }
                }, label: {
                    Text("Orders")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(.black)
                })
                    .padding()
                
                Button(action: {
                    lvm.logOut()
                }, label: {
                    Text("Logout")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(.black)
                })
                    .padding()
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(uvm: UserViewModel(), lvm: LoginViewModel())
    }
}
