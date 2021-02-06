//
//  Detail.swift
//  Happytime
//
//  Created by Shinya on 2021/01/18.
//

import SwiftUI

struct Detail: View {
    @EnvironmentObject var modelData: DBViewModel
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                
                Text("hello")
            }
            
        }
    }
}

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        Detail()
    }
}
