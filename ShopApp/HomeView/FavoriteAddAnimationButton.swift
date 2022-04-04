//
//  FavoriteAddAnimationButton.swift
//  ShopApp
//
//  Created by Hendrik Steen on 16.01.22.
//

import SwiftUI

struct FavoriteAddAnimationButton: View {
    @State private var doAnimation = false
    @State private var disableButton = false
    @State private var addedOrNot = false
    let addAction: () -> Void
    let checkFavoriteAction: () -> Bool
    var body: some View {
        //Diese View stellt den Button zum Hinzufügen eines Artikel in die Favoritenliste in der ItemDetail View dar.
        ZStack {
            Button(action: {
                //Hier muss nur fullAnimation() und nicht addAction() aufgerufen werden, weil diese bereits in Zeile 59 aufgerufen wird.
                fullAnimation()
            }, label: {
                Text(checkFavoriteAction() ? "Added" : "Add to Favorites")
                    .foregroundColor(disableButton ? .gray.opacity(0.05) : .black)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(.gray.opacity(0.25))
                    .cornerRadius(15, antialiased: false)
            })
            //linkes
            Image(systemName: addedOrNot ? "heart.fill" : "heart")
                .foregroundColor(.white)
                .offset(x: doAnimation ?
                        UIScreen.main.bounds.width / 2 - 125:
                            -UIScreen.main.bounds.width / 2 + 125)
                .scaleEffect(2.0)
                .opacity(doAnimation ? 0 : 1.0)
            //rechtes
            Image(systemName: addedOrNot ? "heart" : "heart.fill")
                .foregroundColor(.white)
                .opacity(doAnimation ? 1.0 : 0)
                .offset(x: doAnimation ? -UIScreen.main.bounds.width / 2 + 125 :
                        UIScreen.main.bounds.width / 2 - 125)
                .scaleEffect(2.0)
        }
        .disabled(disableButton)
        .onAppear() {
            //Beim Auftauchen der View muss überprüft werden, ob der Artikel bereits als Favorit markiert ist, damit der richtige Status angezeigt wird.
            doAnimation = false
            addedOrNot = false
            if checkFavoriteAction() == true {
                addedOrNot = true
            }
        }
    }
    private func fullAnimation() {
        //Diese Funktion sorgt für die Animation beim Hinzufügen eines Artikels.
        disableButton = true
        addAction()
        withAnimation(.easeOut(duration: 2.0)) {
            doAnimation.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            disableButton = false
        }
    }
}

struct FavoriteAddAnimationButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteAddAnimationButton(addAction: {
            
        }, checkFavoriteAction: {
            return false
        })
    }
}
