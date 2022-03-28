//
//  CatDetailView.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/26.
//

import SwiftUI

struct CatDetailView: View {
    
    @EnvironmentObject var detailVMModel: CatDetailViewModel
    @State var engLevel: Int? = 0
    
    var body: some View {
        
        VStack(alignment: .leading) {
            AsyncImageView(urlString: "\(detailVMModel.image)")
                .frame(width: 350, height: 300)
                .scaledToFit()
                .clipped()
            HStack() {
                Image("icon_location")
                    .frame(width: 16, height: 20)
                Text("\(detailVMModel.origin)")
                    .multilineTextAlignment(.leading)
            }.padding(.top, 10)
            
            Text("Temperament : ")
                .font(Font.body.bold())
                .multilineTextAlignment(.leading)
                .padding(.top, 20)
            Text("\(detailVMModel.temperament)")
                .multilineTextAlignment(.leading)
                .padding(.top, 5)
            
            Text("Energy level : ")
                .font(Font.body.bold())
                .padding(.top, 20)
            
            RatingView(rating: $detailVMModel.energyLevel, max: 5)
                .padding(.top, 5)
           
            Spacer()
        }
        .navigationBarTitle("\(detailVMModel.name)")
    }
}

struct RatingView: View {
    
    @Binding var rating: Int
    var max: Int = 5
    
    var body: some View {
        HStack {
            ForEach(1..<(max + 1), id: \.self) { index in
                Image(systemName: self.starType(index: index))
                    .foregroundColor(Color.orange)
            }
        }
    }
    
    private func starType(index: Int) -> String {
        return index <= rating ? "star.fill" : "star"
    }
}

struct CatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CatDetailView()
    }
}



struct AsyncImageView: View {
    var urlString: String
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var image: UIImage = UIImage()
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .clipped()
            .aspectRatio(contentMode: .fill)
            .onReceive(imageLoader.$image) { image in
                self.image = image
            }
            .onAppear {
                imageLoader.loadImage(for: urlString)
            }
    }
}

class ImageLoaderService: ObservableObject {
    @Published var image: UIImage = UIImage()
    
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data) ?? UIImage()
            }
        }
        task.resume()
    }
}
