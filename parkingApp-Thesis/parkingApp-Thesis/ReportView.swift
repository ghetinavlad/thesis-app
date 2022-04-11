//
//  ReportView.swift
//  parkingApp-Thesis
//
//  Created by vladut on 4/9/22.
//

import SwiftUI
import MapKit

struct ReportView: View {
    @Binding var showDetails: Bool
    @StateObject var viewModel: MapViewModel
    let details: Spot
    var dismissAction: (() -> Void)
    @State private var isDuplicatedSpotSelected: Bool = false
    @State private var isInappropiateContentSelected: Bool = false
    @State private var isSpotNoLongerAvailable: Bool = false
    @State private var isOtherSelected: Bool = false
    @State private var showErrorMessage: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            Button(action: {
                self.dismissAction()
            }, label: {
                Image(systemName: "xmark")
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color.white)
                    .padding(.top, 40)
                    .padding(.trailing, 20)
                
            })
            .zIndex(10)
            VStack{
                Image("report")
                    .resizable()
                    .frame(width: 86, height: 86)
                Text("Please select one or more issues that you have encountered")
                    .fontWeight(.regular)
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 25)
                
                Spacer()
                    .frame(height: 60)
                
                VStack(alignment: .leading) {
                    CheckBoxView(isOptionSelected: $isDuplicatedSpotSelected, option: "Duplicated spot")
                    CheckBoxView(isOptionSelected: $isInappropiateContentSelected, option: "Inappropiate content")
                    CheckBoxView(isOptionSelected: $isSpotNoLongerAvailable, option: "Spot is no longer available")
                    CheckBoxView(isOptionSelected: $isOtherSelected, option: "Other")
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                    .frame(height: 40)
                
                Button(action: {
                    if isDuplicatedSpotSelected || isInappropiateContentSelected || isSpotNoLongerAvailable || isOtherSelected {
                        viewModel.updateParkingspot(id: details.id, nrOfReports: details.nrOfReports)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.showDetails = false
                            self.dismissAction()
                        }
                    }
                    else {
                        showErrorMessage = true
                    }
                }, label: {
                    Text("Report")
                        .foregroundColor(Color.black)
                })
                .buttonStyle(GrowingButton5())
                
                Text(showErrorMessage ? "Please select at least one option in order to report" : "")
                    .font(.system(size: 13))
                    .padding(.horizontal, 25)
                    .foregroundColor(Color.red)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 30)
                
            }
            .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.65)
            .background(Color(red: 29/255, green: 29/255, blue: 27/255)).opacity(0.9)
            .cornerRadius(8)
            .padding(.top, 20)
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(showDetails: .constant(false), viewModel: MapViewModel(), details: Spot(id: "", coordinate: CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0), occupationRate: 0, postedAt: "", reporter: "", zone: "", note: "", nrOfReports: 0), dismissAction: {})
    }
}
