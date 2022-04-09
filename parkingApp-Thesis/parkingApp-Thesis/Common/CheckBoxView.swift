//
//  CheckBoxView.swift
//  parkingApp-Thesis
//
//  Created by vladut on 4/9/22.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var isOptionSelected: Bool
    var option: String
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                self.isOptionSelected = !self.isOptionSelected
            }, label: {
                if self.isOptionSelected {
                    Image("checked")
                } else {
                    Image("unchecked")
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                }
            })
            
            Text(option)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 192/255, green: 192/255, blue: 192/255))
        }
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxView(isOptionSelected: .constant(false), option: "")
    }
}
