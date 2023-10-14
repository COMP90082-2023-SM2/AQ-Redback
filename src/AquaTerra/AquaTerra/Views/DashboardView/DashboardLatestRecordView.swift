//
//  DashboardLatestRecordsView.swift
//  AquaTerra
//
//

import SwiftUI

struct DashboardLatestRecordView: View {
    @Binding var isDashboardDetailPresented: Bool
    let record: MoistureData
    var body: some View {
        VStack {
//            HStack {
//                Text("The Latest Records")
//                    .font(.custom("OpenSans-SemiBold", size: 16))
//                Spacer()
//            }
            VStack{
                HStack {
                    Text("Moisture 30-50 cm")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                    Spacer()
                    Text("\(formateNumber(record.moistureDepth50!))%")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .frame(width: 65, height: 26)
                        .background(Color("HighlightColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
                HStack {
                    Text("Moisture 100 cm")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                    Spacer()
                    Text("\(formateNumber(record.moistureDepth100!))%")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .frame(width: 65, height: 26)
                        .background(Color("HighlightColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
                HStack {
                    Text("Moisture 150cm")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                    Spacer()
                    Text("\(formateNumber(record.moistureDepth150!))%")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .frame(width: 65, height: 26)
                        .background(Color("HighlightColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
                HStack {
                    Text("Temperature")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                    Spacer()
                    Text("\(formateNumber(record.temperature))℃")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .frame(width: 65, height: 26)
                        .background(Color("HighlightColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
                HStack {
                    Text("Battery")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                    Spacer()
                    Text("\(formateNumber(record.battery_vol))V")
                        .font(.custom("OpenSans-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .frame(width: 65, height: 26)
                        .background(Color("HighlightColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
                
                Spacer().frame(width: 10)
                Button {
                    isDashboardDetailPresented = true
                } label: {
                    Text("See Details")
                        .font(.custom("OpenSans-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background {
                            LinearGradient(colors: [
                                Color(cgColor: .init(red: 0.499, green: 0.685, blue: 0.277, alpha: 1)),
                                Color(cgColor: .init(red: 0.522, green: 0.702, blue: 0.642, alpha: 1)),
                            ], startPoint: .leading, endPoint: .trailing)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
                .buttonStyle(.plain)
                
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 30)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.10), radius: 3)
            }
        }
    }

    private func formateNumber(_ number: Double) -> String {
        return String(format: "%.2f", number)
    }
}
