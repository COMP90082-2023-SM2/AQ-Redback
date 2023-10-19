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
    @ObservedObject var viewModel: DashboardViewModel
    var longitude = 144.9631
    var latitude = 37.813
    
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
                            .padding(.top, 20)
                            
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
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Weather Now")
                                .bold()
                                .padding(.bottom)
                                .font(.custom("OpenSans-Bold", size: 16))
                            
                            
                            HStack {
                                WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble()), unit:("°"))
                                Spacer().frame(width: 45)
                                WeatherRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() ), unit: ("m/s"))
                            }
                            
                            HStack {
                                WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble()), unit: ("°"))
                                Spacer().frame(width: 45)
                                WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())", unit: ("%"))
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
                               if let pointsString = viewModel.sensorSelection.points,
                                   let jsonData = pointsString.data(using: .utf8),
                                   let points = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                                   let coordinates = points["coordinates"] as? [Double] {
                                   let latitude = coordinates[1]
                                   let longitude = coordinates[0]
                                   weather = try await weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude)
                               } else {
                                   print("Error getting weather")
                               }
                           } catch {
                               print("Error getting weather: \(error)")
                           }
                       }
               }
        }
    }
}

