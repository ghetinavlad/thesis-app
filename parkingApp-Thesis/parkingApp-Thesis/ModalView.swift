//
//  ModalView.swift
//  parkingApp-Thesis
//
//  Created by vladut on 4/10/22.
//

import SwiftUI

struct ModalView: View {
    @Binding var showNoInternetConnection: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            if showNoInternetConnection {
                VStack {
                    Image("no-wifi")
                        .foregroundColor(Color.black)
                        .padding(.top, 30)
                    Text("No connection")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .padding(.top, 10)
                    Text("Slow or no internet connection")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(Color.gray)
                        .padding(.top, 5)
                    Text("Please check your internet settings and try again")
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(Color.gray)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                    }, label: {
                        Text("Retry")
                            .foregroundColor(Color.black)
                    })
                    .buttonStyle(GrowingButton6())
                    .padding(.top, 10)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2.1)
                .background(Color.white)
                .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                .transition(.move(edge: .top))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(showNoInternetConnection: .constant(false))
    }
}
