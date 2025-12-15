//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 15/12/25.
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            List(viewModel.cellViewModel) {
                viewModel in
                HStack {
                    Image(uiImage: viewModel.image!)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                    Text(viewModel.title)
                        .padding(.leading, 10)
                }
                .padding(.bottom, 3)
                
            }
    }
}

#Preview {
    RMSettingsView(viewModel: .init(cellViewModel: RMSettingsOption.allCases.compactMap({
        return RMSettingsCellViewModel(type: $0)
    })))
}
