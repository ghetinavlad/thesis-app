//
//  MapView.swift
//  maps
//
//  Created by vladut on 2/23/22.
//

import Foundation
import UIKit
import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI

struct MyAnnotationItem: Identifiable {
    var coordinate: CLLocationCoordinate2D
    var id: Int
    var type: String
    var occupationRate: Int
    var reporter: String
    var time: Int
    var reporterRating: Int
}

struct Spot: Identifiable {
    var id: String
    var coordinate: CLLocationCoordinate2D
    var occupationRate: Int
    var postedAt: String
    var reporter: String
    var zone: String
    var note: String
    var nrOfReports: Int
}

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State var center = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.770439, longitude: 23.591423), span: MKCoordinateSpan(latitudeDelta: 0.045, longitudeDelta: 0.045))
    @State var radius: CGFloat = 0.5
    @State var lat: Double = 0.2
    @State var long: Double = 0.2
    @State var isHiddenPreview: Bool = true
    @State var selectedPin: String = ""
    @State var showDetails: Bool = false
    @State var showUploadImage: Bool = false
    @State var tracking: MapUserTrackingMode = .follow
    @State var timeRemaining = -1
    @State var toTime: CGFloat = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    
    @State private var didTap: Bool = false
    
    private var xOffset: CGFloat {
        return didTap ? 10.0 : 0.0
    }
    
    var body: some View {
        ZStack{
            if viewModel.isLoading {
                LoadingIndicator()
                    .zIndex(10)
            }
            ZStack(alignment: .topTrailing){
                Map(coordinateRegion: $center, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: viewModel.spots , annotationContent:  {
                    location in MapAnnotation(coordinate: location.coordinate) {
                        ZStack{
                            VStack{
                                ZStack(alignment: .topTrailing){
                                    Image("preview-car-2")
                                        .resizable()
                                        .frame(maxWidth: .infinity, maxHeight: 100)
                                    Button(action: {
                                        if selectedPin == location.id {
                                            isHiddenPreview.toggle()
                                        }
                                    }, label: {
                                        Image("close-preview")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.white)
                                            .background(Color.gray)
                                            .cornerRadius(50)
                                            .padding(1.5)
                                    })
                                    
                                }
                                Spacer()
                                HStack{
                                    Text("8 mins ago")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.black)
                                        .fontWeight(.light)
                                    HStack{
                                        Image("red-circle")
                                            .resizable()
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .padding(.horizontal, 4)
                                Spacer()
                            }
                            .sheet(isPresented: selectedPin == location.id ? $showDetails : .constant(false), onDismiss: {
                                if selectedPin == location.id {
                                    timeRemaining = 20
                                    showDetails = false }
                                
                            }, content: {
                                DetailsXView(isSheetPresented: $showDetails, viewModel: viewModel, details: location)
                            })
                            .frame(width: 100, height: 130)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                            .padding(.bottom, 100)
                            .padding(.leading, 50)
                            .zIndex(2)
                            .isHidden(selectedPin == location.id ? isHiddenPreview : true)
                            
                            ZStack(alignment: .topTrailing) {
                                Image("parking")
                                    .resizable()
                                    .frame(width: 34, height: 34)
                                    .foregroundColor(Color.blue)
                                    .onTapGesture {
                                        
                                        selectedPin = location.id
                                        if timeRemaining == -1 {
                                            showDetails = true
                                        }
                                    }
                                    .onLongPressGesture {
                                        withAnimation{
                                            //print(location)
                                            selectedPin = location.id
                                            isHiddenPreview.toggle()
                                            
                                        }
                                        
                                    }
                                    .zIndex(1)
                                if location.nrOfReports >= 2 {
                                    Image("exclamation-mark")
                                        .padding(.top, -5)
                                        .zIndex(10)
                                }
                            }
                        }
                        
                    }
                })
                .accentColor(Color(.systemPink))
                .onAppear{
                    viewModel.isLocationServiceEnabled()
                }
                VStack(spacing: 15){
                    Button(action:
                            {
                        withAnimation   {
                            viewModel.isLocationAuthorization()
                            lat = 0.0035
                            long = 0.0035
                            center = viewModel.region
                            radius = 0
                        }
                        
                        
                    }
                           , label: {
                        Image(systemName: "location.fill")
                            .foregroundColor(Color.red)
                            .frame(width: 30, height: 30)
                    })
                    .buttonStyle(GrowingButton())
                    if self.timeRemaining != -1 {
                        ZStack {
                            Circle()
                                .trim(from: 0, to: 1)
                                .stroke(Color.red, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .frame(width: 30, height: 30)
                            Circle()
                                .trim(from: 0, to: self.toTime)
                                .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .frame(width: 30, height: 30)
                            Text("\(timeRemaining)")
                                .onReceive(timer) { _ in
                                    if timeRemaining > -1 {
                                        timeRemaining -= 1
                                        withAnimation(.default) {
                                            self.toTime = CGFloat(self.timeRemaining) / 20
                                        }
                                    }
                                }
                        }
                    }
                    
                }
                .padding(.trailing, 35)
                .padding(.top, 75)
                
            }
            .sheet(isPresented: $showUploadImage, onDismiss: {
                showUploadImage = false
            }, content: {
                AddSpotView(showUploadImage: $showUploadImage, viewModel: viewModel)
                
            })
            
            ZStack {
                Button(action: {
                    self.showUploadImage = true
                    print("OK")
                }, label: {
                    Image("plus")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.red)
                        .frame(width: 22, height: 22)
                })
                .buttonStyle(GrowingButton3())
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            Spacer()
        }
        .opacity(viewModel.isLoading ? 0.4 : 1)
        .onAppear {
            self.viewModel.fetchSpots()
            
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
        
        
        
    }
}

struct ChartView: View {
    let rate: Int
    
    var body: some View {
        HStack(spacing: 4){
            ForEach(1..<(rate)) { i in
                Capsule()
                    .frame(width: 8 , height: 8 + CGFloat(i * 6))
                    .foregroundColor(Color.red)
            }
        }
        .frame(height: 32)
    }
}

func getCurrentTime() -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    let dateString = formatter.string(from: Date())
    var romanianTime = dateString.replacingOccurrences(of: "PM", with: "")
    romanianTime = romanianTime.replacingOccurrences(of: "AM", with: "")
    
    return romanianTime
}

func getTimeLeft(time: String) -> String{
    
    let delimiter = ":"
    var token = time.components(separatedBy: delimiter)
    let initialTimeValue = (Int(token[0]) ?? 0)*60 + (Int(token[1]) ?? 0)
    token = getCurrentTime().components(separatedBy: delimiter)
    let currentTimeValue = (Int(token[0]) ?? 0)*60 + (Int(token[1]) ?? 0)
    var timeElapsed = currentTimeValue - initialTimeValue
    
    if timeElapsed < 0 {
        timeElapsed *= -1
    }
    
    if timeElapsed == 0 {
        return "just now"
    } else if timeElapsed < 60 {
        return "\(timeElapsed) mins ago"
    } else {
        return "\(timeElapsed / 60) hours ago"
    }
}

struct DetailsXView: View {
    @Binding var isSheetPresented: Bool
    @State var showReporting: Bool = false
    @ObservedObject var viewModel: MapViewModel
    let details: Spot
    @State private var locationIsCloseEnough: Bool = true
    
    var body: some View {
        VStack(spacing: 30){
            VStack {
                HStack{
                    Spacer()
                    Button(action: {
                        isSheetPresented = false
                    }, label: {
                        Image("close-preview")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                            .cornerRadius(50)
                            .padding(3)
                            .padding(.top, 5)
                        
                    })
                }
                DetailsView(details: details, viewModel: DetailsViewModel())
                    .padding(.horizontal, 20)
                
            }
            .padding(.top, 130)
            .frame(height: UIScreen.main.bounds.height / 2.2)
            .padding()
            .background(Color.white)
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
            
            Spacer()
            
            VStack{
                VStack{
                    if viewModel.imageURL.isEmpty {
                        LoadingIndicator()
                    } else {
                        AnimatedImage(url: URL(string: viewModel.imageURL))
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 3.5)
                            .cornerRadius(10)
                            .shadow(color: Color.darkShadow, radius: 3, x: 3, y: 3)
                            .shadow(color: Color.lightShadow, radius: 3, x: -3, y: -2)
                    }
                    
                    HStack {
                        Text(getTimeLeft(time: details.postedAt))
                            .font(.system(size: 12))
                            .foregroundColor(Color.black)
                            .fontWeight(.medium)
                            .padding(.leading, 5)
                        Spacer()
                        Button(action: {
                            self.showReporting = true
                        }, label: {
                            Image("attention")
                        })
                        .padding(.top, -20)
                    }
                    .padding(.horizontal, 35)
                    .padding(.top, -20)
                }
                
                Button(action: {
                    viewModel.deleteParkingSpot(id: details.id)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isSheetPresented = false
                    }
                }, label: {
                    HStack(spacing: 10){
                        if locationIsCloseEnough {
                            Text("Reserve")
                                .font(.system(size: 18))
                                .foregroundColor(Color.black)
                                .fontWeight(.regular)
                            
                            Image("accept")
                                .resizable()
                                .frame(width: 24, height: 24)
                        } else {
                            Text("Unable to reserve")
                                .font(.system(size: 18))
                                .foregroundColor(Color.black)
                                .fontWeight(.regular)
                            
                            Image("error")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.leading, 45)
                    .padding(.trailing, 45)
                    .padding(.vertical, 14)
                    .cornerRadius(10)
                })
                .buttonStyle(GrowingButton2())
                .padding(.top, 10)
                .disabled(!locationIsCloseEnough)
                Spacer()
            }
            .onAppear {
                locationIsCloseEnough = viewModel.checkDistanceBetweenUserAndLocation(location: CLLocation(latitude: details.coordinate.latitude, longitude: details.coordinate.longitude))
                viewModel.loadImageFromFirebase(id: details.id)
            }
            
            .padding(.top, 35)
            .padding(.bottom, 60)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.6)
            
            .background(Color.white)
            .cornerRadius(15, corners: [.topLeft, .topRight])
            .shadow(color: Color.lightShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.darkShadow, radius: 3, x: -2, y: -2)
        }
        .interactiveDismissDisabled(showReporting)
        .alertLink(isPresented: $showReporting, destination: {
            ReportView(showDetails: $isSheetPresented, viewModel: viewModel, details: details, dismissAction: {self.showReporting = false})
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 248 / 255, green: 245 / 255, blue: 237 / 255).edgesIgnoringSafeArea(.all))
    }
}


final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.770439, longitude: 23.591423), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @Published var spots = [Spot]()
    @Published var imageURL = ""
    @Published var isLoading = false
    
    /*@Published var locations: [MyAnnotationItem] = [
     MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 46.770439, longitude: 23.591423), id: 0, type: "small" , occupationRate: 4, reporter: "Vlad G", time: 16, reporterRating: 4),
     MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 46.56667, longitude: 23.78333), id: 1, type: "large" , occupationRate: 2, reporter: "Vlad G", time: 16, reporterRating: 4),
     MyAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 47.790001, longitude: 22.889999), id: 2, type: "medium" , occupationRate: 3, reporter: "Vlad G", time: 16, reporterRating: 4)
     ]*/
    private var db = Firestore.firestore()
    let storage = Storage.storage()
    
    func isLocationServiceEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("OFF")
        }
    }
    
    func fetchSpots() {
        self.isLoading = true
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            DispatchQueue.main.async {
                
                self.spots = documents.map{ (QueryDocumentSnapshot) -> Spot in
                    let data = QueryDocumentSnapshot.data()
                    
                    let id = data["id"] as? String ?? ""
                    let latitude = data["latitude"] as? CLLocationDegrees ?? 0.0
                    let longitude = data["longitude"] as? CLLocationDegrees ?? 0.0
                    let occupationRate = data["occupationRate"] as? Int ?? 0
                    let postedAt = data["postedAt"] as? String ?? ""
                    let reporter = data["reporter"] as? String ?? ""
                    let zone = data["zone"] as? String ?? ""
                    let nrOfReports = data["nrOfReports"] as? Int ?? 0
                    let note = data["note"] as? String ?? ""
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    return Spot(id: id, coordinate: coordinate, occupationRate: occupationRate, postedAt: postedAt, reporter: reporter, zone: zone, note: note, nrOfReports: nrOfReports)
                }
                self.isLoading = false
            }
        }
        
        
        
    }
    
    func addParkingSpot(occupationRate: Int, zone: String, note: String, image: UIImage?) {
        var id = randomString()
        if let coordinates = locationManager?.location!.coordinate {
            db.collection("spots").addDocument(data: [
                "id": id,
                "occupationRate": occupationRate,
                "latitude":  coordinates.latitude,
                "longitude": coordinates.longitude,
                "postedAt": getCurrentTime(),
                "reporter": UserDefaults.standard.object(forKey: "username")!,
                "zone": zone,
                "note": note,
                "nrOfReports": 0
            ])
            if let image = image {
                storage.reference().child(id).putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil) { (_, err) in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    print("success")
                }
            }
        }
    }
    
    func deleteParkingSpot(id: String) {
        db.collection("spots").whereField("id", isEqualTo: id).getDocuments{(snap, err) in
            if err != nil {
                print("Error")
                return
            }
            for doc in snap!.documents {
                DispatchQueue.main.async {
                    doc.reference.delete()
                }
            }
        }
    }
    
    func updateParkingspot(id: String, nrOfReports: Int) {
        db.collection("spots").whereField("id", isEqualTo: id).getDocuments{(snap, err) in
            if err != nil {
                print("Error")
                return
            }
            for doc in snap!.documents {
                DispatchQueue.main.async {
                    doc.reference.updateData(
                        [
                            "nrOfReports": nrOfReports + 1
                        ]
                    )
                }
            }
        }

    }
    
    func loadImageFromFirebase(id: String) {
        let storage = Storage.storage().reference(withPath: id)
        storage.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            print("Download success")
            self.imageURL = "\(url!)"
            
        }
    }
    
    func checkDistanceBetweenUserAndLocation(location: CLLocation) -> Bool {
        if let coordinates = self.locationManager?.location!.coordinate {
            var userLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            return userLocation.distance(from: location) <= 15
        } else {
            print("EROR IDENTIFYING YOUR LOCATION")
        }
        return false
    }
    
    func isLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("RESTRICTED")
        case .denied:
            print("DENIED AUTH")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0035, longitudeDelta: 0.0035))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        isLocationAuthorization()
    }
}


struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        //.frame(width: 30, height: 30)
            .foregroundColor(.neumorphictextColor)
            .background(Color.white)
            .cornerRadius(6)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.315), value: configuration.isPressed)
    }
}
struct GrowingButton3: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        //.frame(width: 30, height: 30)
            .foregroundColor(.neumorphictextColor)
            .padding(12)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.315), value: configuration.isPressed)
    }
}
struct GrowingButton5: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        //.frame(width: 30, height: 30)
            .foregroundColor(.neumorphictextColor)
            .padding(10)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.darkShadow, radius: 2, x: 1, y: 1)
            .shadow(color: Color.darkShadow, radius: 2, x: -1, y: -1)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.315), value: configuration.isPressed)
    }
}
struct GrowingButton2: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        //.frame(width: 30, height: 30)
            .foregroundColor(.neumorphictextColor)
            .background(Color(red: 255 / 255, green: 168 / 255, blue: 54 / 255))
            .cornerRadius(8)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.315), value: configuration.isPressed)
    }
}
struct DisabledGrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        //.frame(width: 30, height: 30)
            .foregroundColor(.gray)
            .background(Color(red: 255 / 255, green: 168 / 255, blue: 54 / 255))
            .cornerRadius(8)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.315), value: configuration.isPressed)
    }
}

struct GrowingButton4: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        //.frame(width: 30, height: 30)
            .foregroundColor(.neumorphictextColor)
            .background(Color(red: 255 / 255, green: 168 / 255, blue: 54 / 255))
            .cornerRadius(10)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.315), value: configuration.isPressed)
    }
}

struct CustomForm: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.neumorphictextColor)
            .background(Color.background)
            .cornerRadius(6)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)
            .frame(maxWidth: .infinity)
        
        
    }
}

extension View {
    func customForm() -> some View {
        modifier(CustomForm())
    }
}

func randomString() -> String {
    let letters = "0123456789abcdefg"
    return String((0..<10).map{ _ in letters.randomElement()! })
}

extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
}
extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}



