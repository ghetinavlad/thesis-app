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
    @Binding var showUploadImage: Bool
    
    @State var sourceType:UIImagePickerController.SourceType = .camera
    
    @StateObject var viewModel: MapViewModel
    @State var image:UIImage?
    @State private var vehicleType = 0
    @State private var occupationRate = 0
    @State private var currentTabArea = "2"
    @State private var currentTabTime = "5 mins"
    @State private var zone = "2"
    @State private var occupateRate = 2
    @State private var note = ""
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
                            Text("Zone 1(A)")
                                .font(.system(size: 13.5, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 105, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabArea == "1" ? 8 : -8, y: self.currentTabArea == "1" ? 8 : -8)
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
                                    self.currentTabArea = "1"
                                    self.zone = "1(A)"
                                }
                            Text("Zone 2(B)")
                                .font(.system(size: 13.5, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 105, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabArea == "2" ? 8 : -8, y: self.currentTabArea == "2" ? 8 : -8)
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
                                    self.currentTabArea = "2"
                                    self.zone = "2(B)"
                                }
                            Text("Free")
                                .font(.system(size: 13.5, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 105, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabArea == "free" ? 8 : -8, y: self.currentTabArea == "free" ? 8 : -8)
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
                                    self.currentTabArea = "free"
                                    self.zone = "free"
                                }
                        }
                        .padding(.top, 15)
                        HStack {
                            Text("Chargeable")
                                .font(.system(size: 13.5, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 105, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabArea == "chargeable" ? 8 : -8, y: self.currentTabArea == "chargeable" ? 8 : -8)
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
                                    self.currentTabArea = "chargeable"
                                    self.zone = "chargeable"
                                }
                            Text("Other")
                                .font(.system(size: 13.5, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 105, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabArea == "other" ? 8 : -8, y: self.currentTabArea == "other" ? 8 : -8)
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
                                    self.currentTabArea = "other"
                                    self.zone = "other"
                                }
                        }
                        .padding(.top, 15)
                    }
                    
                    Divider()
                        .padding(.horizontal, 30)
                    
                    VStack(spacing: 5) {
                        HStack {
                            Image("pin")
                            VStack {
                            Text("Estimated time until occupied")
                                .fontWeight(.medium)
                                .foregroundColor(Color.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("*it might depend on the local time and area")
                                .fontWeight(.medium)
                                .foregroundColor(Color.black)
                                .font(.system(size: 11.5))
                                .padding(.leading, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.leading, 20)
                        HStack {
                            Text("< 5 mins")
                                .font(.system(size: 13.5, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 105, height: 42)
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
                                    self.currentTabTime = "< 5 mins"
                                    self.occupationRate = 1
                                }
                            Text("15 - 30 mins")
                                .font(.system(size: 13.5, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 105, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabTime == "15 - 30 mins" ? 8 : -8, y: self.currentTabTime == "15 - 30 mins" ? 8 : -8)
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
                                    self.currentTabTime = "15 - 30 mins"
                                    self.occupationRate = 2
                                }
                            Text("> 45 mins")
                                .font(.system(size: 13.5, weight: .medium, design: .rounded))
                                .foregroundColor(Color.black)
                                .frame(width: 105, height: 42)
                                .background(
                                    ZStack {
                                        Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .foregroundColor(.white)
                                            .blur(radius: 4)
                                            .offset(x: self.currentTabTime == "> 45 mins" ? 8 : -8, y: self.currentTabTime == "> 45 mins" ? 8 : -8)
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
                                    self.currentTabTime = "> 45 mins"
                                    self.occupationRate = 3
                                }
                        }
                        .padding(.top, 15)
                    }
                    
                    Divider()
                        .padding(.horizontal, 30)
                    
                    MultilineTextField("Leave a note here", text: $note, onCommit: {
                        print("Final text: \(note)")
                    })
                        .foregroundColor(Color.black)
                        .frame(width: UIScreen.main.bounds.width / 1.3, height: 120, alignment: .top)
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
                        viewModel.addParkingSpot(occupationRate: occupationRate, zone: zone, note: note, image: image ?? UIImage(named: "no-image"))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showUploadImage = false
                        }
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
                    .buttonStyle(GrowingButton11())
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
        AddSpotView(showUploadImage: .constant(false), viewModel: MapViewModel())
    }
}
