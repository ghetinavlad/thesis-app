//
//  DetailsView.swift
//  maps
//
//  Created by vladut on 2/27/22.
//

import SwiftUI

struct DetailsView: View {
    let details: Spot
    
    @ObservedObject var viewModel: DetailsViewModel
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
                            .fixedSize(horizontal: false, vertical: true)
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
                .padding(.bottom, -12)
            }
            .padding(.vertical, 10)
            .onAppear{
                viewModel.getAddressesFromCoordinates(latitude: details.coordinate.latitude, longitude: details.coordinate.longitude)
            }
        }
    }
}

