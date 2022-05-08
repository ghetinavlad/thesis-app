//
//  DetailsView.swift
//  maps
//
//  Created by vladut on 2/27/22.
//

import SwiftUI

struct DetailsView: View {
    let details: Spot
    
    @StateObject var viewModel: DetailsViewModel
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 14){
                HStack(alignment: .center) {
                    Text("Occupation Rate")
                        .foregroundColor(Color.black)
                    Spacer()
                    ChartView(rate: details.occupationRate+1)
                }
                Divider()
                HStack(alignment: .center) {
                    Text("Address")
                        .foregroundColor(Color.black)
                    Spacer()
                    if viewModel.isLoading == false {
                        if viewModel.addressFromCoordinates == "" {
                            LoadingIndicator()
                        }else {
                            Text(viewModel.addressFromCoordinates)
                                .foregroundColor(Color.gray)
                                .lineLimit(3)
                                .frame(width: UIScreen.main.bounds.width / 2, alignment: .trailing)
                        }
                    }
                    else {
                        LoadingIndicator()
                    }
                }
                Divider()
                HStack(alignment: .center) {
                    Text("Posted at")
                        .foregroundColor(Color.black)
                    Spacer()
                    Text(details.postedAt)
                        .foregroundColor(Color.gray)
                }
                Divider()
                HStack(alignment: .center) {
                    Text("Zone")
                        .foregroundColor(Color.black)
                    Spacer()
                    Text(details.zone)
                        .foregroundColor(Color.gray)
                }
                if !details.note.isEmpty {
                    Divider()
                    HStack(alignment: .center) {
                        Text("Note")
                            .foregroundColor(Color.black)
                        Spacer()
                        Text(details.note)
                            .foregroundColor(Color.gray)
                            .lineLimit(3)
                            .frame(width: UIScreen.main.bounds.width / 2, alignment: .trailing)
                    }
                }
                
                Group{
                    Text("Reported by ")
                        .foregroundColor(Color.black)
                        .fontWeight(.semibold)
                    +
                    Text(details.reporter)
                        .font(.system(size: 16))
                        .foregroundColor(Color.red)
                        .fontWeight(.bold)
                }
                .padding(.top, 10)
                .padding(.bottom, -12)
            }
            .padding(.vertical, 10)
            .onAppear{
                viewModel.getAddressesFromCoordinates(latitude: details.coordinate.latitude, longitude: details.coordinate.longitude)
                
            }
        }
    }
}

