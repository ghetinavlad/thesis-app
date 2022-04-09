//
//  ReportView.swift
//  parkingApp-Thesis
//
//  Created by vladut on 4/9/22.
//

import SwiftUI

struct ReportView: View {
    @Binding var showDetails: Bool
    var dismissAction: (() -> Void)
    @State private var isDuplicatedSpotSelected: Bool = false
    @State private var isInappropiateImageSelected: Bool = false
    @State private var isSpotNoLongerAvailable: Bool = false
    @State private var isOtherSelected: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            Button(action: {
                self.dismissAction()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.white)
                    .padding()
            }).zIndex(10)
            VStack{
                Image("report")
                    .resizable()
                    .frame(width: 86, height: 86)
                Text("Please select one or more issues that you have encountered")
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 25)
                
                Spacer()
                    .frame(height: 50)
                
                VStack(alignment: .leading) {
                    CheckBoxView(isOptionSelected: $isDuplicatedSpotSelected, option: "Duplicated spot")
                    CheckBoxView(isOptionSelected: $isInappropiateImageSelected, option: "Inappropiate image")
                    CheckBoxView(isOptionSelected: $isSpotNoLongerAvailable, option: "Spot is no longer available")
                    CheckBoxView(isOptionSelected: $isOtherSelected, option: "Other")
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(height: 40)
                
                Button(action: {
                    self.showDetails = false
                    self.dismissAction()
                }, label: {
                    Text("Report")
                        .foregroundColor(Color.black)
                })
                .buttonStyle(GrowingButton5())
                
            }
            .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.8)
            .background(Color(red: 29/255, green: 29/255, blue: 27/255)).opacity(0.9)
            .cornerRadius(8)
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(showDetails: .constant(false), dismissAction: {})
    }
}
