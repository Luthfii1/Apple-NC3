//
//  HourDetailsCell.swift
//  Weather
//
//  Created by Glenn Leonali on 11/07/24.
//

import SwiftUI
import WeatherKit

struct HourDetailsCell: View {
    var hourWeather: HourWeather?
    var body: some View {
        if let hour = hourWeather {
            VStack {
                Text(hour.date.formatted(.dateTime.hour()))
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(Color.white)

                Image(systemName: hour.symbolName+".fill")
                    .font(.system(size: 22.0, weight: .bold))
                    .padding(.bottom, 3.0)
                    .frame(height: 24)
                    .foregroundStyle(Color.white)

                Text("\(hour.temperature.value.formatted(.number.precision(.fractionLength(0))))°")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(Color.white)
            }
        }
    }
}

struct HourDetailsCell_Previews: PreviewProvider {
    static var previews: some View {
        HourDetailsCell()
    }
}
