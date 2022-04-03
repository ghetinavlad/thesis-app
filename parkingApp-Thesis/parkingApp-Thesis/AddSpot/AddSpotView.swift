//
//  AddSpotView.swift
//  parkingApp-Thesis
//
//  Created by vladut on 3/13/22.
//

import SwiftUI
import FirebaseStorage

struct AddSpotView: View {
    @State var showActionSheet = false
    @State var showImagePicker = false
    
    @State var sourceType:UIImagePickerController.SourceType = .camera
    
    @ObservedObject var viewModel: MapViewModel
    @State var image:UIImage?
    @State private var vehicleType = 0
    @State private var occupationRate = 0
    @State private var currentTabArea = "A"
    @State private var currentTabTime = "5 mins"
    @State private var zone = "2"
    @State private var occupateRate = 2
    @State private var details = ""
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    let storage = Storage.storage()
    
    var body: some View {
        
        VStack {
            if image != nil {
                ZStack(alignment: .bottomTrailing) {
                    Image(uiImage: image!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 1.15, height: 230)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1.5  )
                        )
                    Button(action: {
                        self.showActionSheet = true
                    }) {
                        Image("retry")
                            .padding(.trailing, 20)
                            .padding(.bottom, 10)
                            .opacity(0.8)
                    }
                    .actionSheet(isPresented: $showActionSheet){
                        ActionSheet(title: Text("Select a method for upload"), message: nil, buttons: [
                            //Button1
                            
                            .default(Text("Camera"), action: {
                                self.showImagePicker = true
                                self.sourceType = .camera
                            }),
                            //Button2
                            .default(Text("Photo Library"), action: {
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                            }),
                            
                            //Button3
                            .cancel()
                            
                        ])
                    }.sheet(isPresented: $showImagePicker){
                        imagePicker(image: self.$image, showImagePicker: self.$showImagePicker, sourceType: self.sourceType)
                            .edgesIgnoringSafeArea(.all)
                        
                    }
                    
                }
            } else {
                ZStack(alignment: .bottomTrailing){
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 200, height: 200)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 0.3)
                            )
                            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
                            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
                        Image("camera")
                    }
                    Button(action: {
                        self.showActionSheet = true
                    }) {
                        Image("upload")
                            .padding(.trailing, 20)
                            .padding(.bottom, 10)
                    }
                    .actionSheet(isPresented: $showActionSheet){
                        ActionSheet(title: Text("Select a method for upload"), message: nil, buttons: [
                            //Button1
                            
                            .default(Text("Camera"), action: {
                                self.showImagePicker = true
                                self.sourceType = .camera
                            }),
                            //Button2
                            .default(Text("Photo Library"), action: {
                                self.showImagePicker = true
                                self.sourceType = .photoLibrary
                            }),
                            
                            //Button3
                            .cancel()
                            
                        ])
                    }.sheet(isPresented: $showImagePicker){
                        imagePicker(image: self.$image, showImagePicker: self.$showImagePicker, sourceType: self.sourceType)
                            .edgesIgnoringSafeArea(.all)
                        
                    }
                    
                }
            }
            
            Spacer()
            ScrollView{
                VStack(spacing: 50) {
                    VStack(spacing: 5) {
                        HStack {
                            Image("pin")
                            Text("Parking area type")
                                .fontWeight(.medium)
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 20)
                        HStack {
                            Text("Area A")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 100, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabArea == "A" ? 8 : -8, y: self.currentTabArea == "A" ? 8 : -8)
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(
                                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8916720748, green: 0.945957005, blue: 0.9388917089, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            )
                                            .padding(2)
                                            .blur(radius: 2)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 10, y: 10)
                                .shadow(color: Color.white, radius: 20, x: -10, y: -10)
                                .onTapGesture {
                                    self.currentTabArea = "A"
                                    self.zone = "1"
                                }
                            Text("Area B")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 100, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabArea == "B" ? 8 : -8, y: self.currentTabArea == "B" ? 8 : -8)
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(
                                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8916720748, green: 0.945957005, blue: 0.9388917089, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            )
                                            .padding(2)
                                            .blur(radius: 2)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 10, y: 10)
                                .shadow(color: Color.white, radius: 20, x: -10, y: -10)
                                .onTapGesture {
                                    self.currentTabArea = "B"
                                    self.zone = "2"
                                }
                            Text("Free")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 100, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabArea == "C" ? 8 : -8, y: self.currentTabArea == "C" ? 8 : -8)
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(
                                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8916720748, green: 0.945957005, blue: 0.9388917089, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            )
                                            .padding(2)
                                            .blur(radius: 2)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 10, y: 10)
                                .shadow(color: Color.white, radius: 20, x: -10, y: -10)
                                .onTapGesture {
                                    self.currentTabArea = "C"
                                    self.zone = "free"
                                }
                        }
                        .padding(.top, 15)
                    }
                    
                    Divider()
                        .padding(.horizontal, 30)
                    
                    
                    Divider()
                        .padding(.horizontal, 30)
                    
                    VStack(spacing: 5) {
                        HStack {
                            Image("pin")
                            Text("Estimated time until occupied")
                                .fontWeight(.medium)
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 20)
                        HStack {
                            Text("< 5mins")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 100, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabTime == "5 mins" ? 8 : -8, y: self.currentTabTime == "5 mins" ? 8 : -8)
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(
                                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8916720748, green: 0.945957005, blue: 0.9388917089, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            )
                                            .padding(2)
                                            .blur(radius: 2)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 10, y: 10)
                                .shadow(color: Color.white, radius: 20, x: -10, y: -10)
                                .onTapGesture {
                                    self.currentTabTime = "5 mins"
                                    self.occupationRate = 1
                                }
                            Text("15 mins")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 100, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabTime == "15 mins" ? 8 : -8, y: self.currentTabTime == "15 mins" ? 8 : -8)
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(
                                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8916720748, green: 0.945957005, blue: 0.9388917089, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            )
                                            .padding(2)
                                            .blur(radius: 2)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 10, y: 10)
                                .shadow(color: Color.white, radius: 20, x: -10, y: -10)
                                .onTapGesture {
                                    self.currentTabTime = "15 mins"
                                    self.occupationRate = 2
                                }
                            Text("> 30 mins")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 100, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabTime == "30 mins" ? 8 : -8, y: self.currentTabTime == "30 mins" ? 8 : -8)
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(
                                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8916720748, green: 0.945957005, blue: 0.9388917089, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            )
                                            .padding(2)
                                            .blur(radius: 2)
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 10, y: 10)
                                .shadow(color: Color.white, radius: 20, x: -10, y: -10)
                                .onTapGesture {
                                    self.currentTabTime = "30 mins"
                                    self.occupationRate = 3
                                }
                        }
                        .padding(.top, 15)
                    }
                    
                    Divider()
                        .padding(.horizontal, 30)
                    
                    TextField("", text: $details)
                        .placeholder(when: details.isEmpty) {
                                Text("Leave a note here").foregroundColor(.gray)
                        }
                        .foregroundColor(Color.black)
                        .frame(width: UIScreen.main.bounds.width / 1.3, height: 150, alignment: .top)
                        .padding()
                        .background(
                            ZStack {
                                Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .foregroundColor(.white)
                                    .blur(radius: 4)
                                    .offset(x: 8, y: 8)
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(
                                        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8916720748, green: 0.945957005, blue: 0.9388917089, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .padding(2)
                                    .blur(radius: 2)
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1)), radius: 20, x: 10, y: 10)
                        .shadow(color: Color.white, radius: 20, x: -10, y: -10)
                    
                    Button(action: {
                        viewModel.addParkingSpot(occupationRate: occupationRate, zone: zone, image: image ?? UIImage(named: "empty"))
                    }, label: {
                        HStack(spacing: 15){
                            Image("add")
                            Text("Add parking spot")
                                .font(.system(size: 16))
                                .foregroundColor(Color.black)
                                .fontWeight(.medium)
                            
                        }
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .padding(.vertical, 14)
                    })
                    .buttonStyle(GrowingButton4())
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, 30)
                .padding(.bottom, 50)
                
                
                
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.8)
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
            .cornerRadius(15, corners: [.topLeft, .topRight])
            .shadow(color: Color.lightShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.darkShadow, radius: 3, x: -2, y: -2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .padding(.top, 50)
        .background(Color(red: 248 / 255, green: 245 / 255, blue: 237 / 255).edgesIgnoringSafeArea(.all))
        
        
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct AddSpotView_Previews: PreviewProvider {
    static var previews: some View {
        AddSpotView(viewModel: MapViewModel())
    }
}
