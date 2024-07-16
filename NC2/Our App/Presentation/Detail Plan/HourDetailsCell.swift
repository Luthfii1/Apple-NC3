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
                    .font(.system(size: 13.0))

                Image(systemName: hour.symbolName)
                    .font(.system(size: 22.0, weight: .bold))
                    .padding(.bottom, 3.0)

                Text("\(hour.temperature.value.formatted(.number.precision(.fractionLength(1))))°")
            }
        }
    }
}

struct HourDetailsCell_Previews: PreviewProvider {
    static var previews: some View {
        HourDetailsCell()
    }
}
