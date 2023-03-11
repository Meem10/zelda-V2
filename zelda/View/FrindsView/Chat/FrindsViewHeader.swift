//
//  FrindsViewHeader.swift
//  zelda
//
//  Created by Aamer Essa on 18/01/2023.
//

import SwiftUI

struct FrindsViewHeader: View {
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack{
            HStack {
                Button(action : {
                    // pop the view when back button pressed
                    self.present.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.white)
                }
                Spacer()
                
                Text("Zelda Player")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }.padding()
            
    } .background(.thinMaterial)
      
}
}
                                     
struct FrindsViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        FrindsViewHeader()
    }
}
