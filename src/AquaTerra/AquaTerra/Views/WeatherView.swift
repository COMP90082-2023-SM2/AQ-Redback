//
//  WeatherView.swift
//  AquaTerra
//
//  Created by Yunqing Yu on 10/10/2023.
//

import SwiftUI

struct WeatherView: View {
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    var longitude = 144.9631
    var latitude = 37.8136
    
    
    var body: some View {
        VStack{
            if let weather = weather {
                VStack{
                    VStack {
                        HStack{
                            VStack(alignment: .leading, spacing: 5) {
                                Text(weather.name)
                                    .font(.custom("OpenSans-Bold", size: 14))
                                
                                Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                                    .font(.custom("OpenSans-Bold", size: 16))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            VStack(spacing: 5) {
                                Image(systemName: "cloud")
                                    .font(.system(size: 30))
                                
                                Text("\(weather.weather[0].main)")
                                    .font(.custom("OpenSans-Bold", size: 14))
                            }
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            
                        }.padding(.horizontal, 30)
                      

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Weather Now")
                                .bold()
                                .padding(.bottom)
                                .font(.custom("OpenSans-Bold", size: 16))
                            
                            
                            HStack {
                                WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + ("°")))
                                Spacer()
                                WeatherRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() + "m/s"))
                            }
                            
                            HStack {
                                WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
    
                                Spacer()
 
                                WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble()) %")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .foregroundColor(Color("ButtonGradient2"))
                        .background(.white)
                        .cornerRadius(20)
                    }.padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    Spacer()
                }.background(Color("ButtonGradient1"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                          
                       
               } else {
                   Text("Loading...")
                       .foregroundColor(Color("ButtonGradient2"))
                       .task {
                           do {
                               weather = try await weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude)
                           } catch {
                               print("Error getting weather: \(error)")
                           }
                       }
               }
        }
    }
}

#Preview {
    WeatherView()
}
