import Foundation

struct WeatherResponse: Codable {
    let liveweer: [LiveWeather]
    let wk_verw: [WeekForecast]
    let uur_verw: [HourlyForecast]
}

struct LiveWeather: Codable, Identifiable {
    var id: UUID { UUID() }
    let plaats: String
    let timestamp: Int
    let time: String
    let temp: Double
    let gtemp: Double
    let samenv: String
    let lv: Int
    let windr: String
    let windrgr: Double
    let windms: Double
    let windbft: Int
    let windknp: Double
    let windkmh: Double
    let luchtd: Double
    let ldmmhg: Int
    let dauwp: Double
    let zicht: Int
    let gr: Int
    let verw: String
    let sup: String
    let sunder: String
    let image: String
    let alarm: Int
    let lkop: String
    let ltekst: String
    let wrschklr: String
    let wrsch_g: String
    let wrsch_gts: Int
    let wrsch_gc: String
}

struct WeekForecast: Codable, Identifiable {
    var id: UUID { UUID() }
    let dag: String
    let image: String
    let max_temp: Int
    let min_temp: Int
    let windbft: Int
    let windkmh: Int
    let windknp: Int
    let windms: Int
    let windrgr: Int
    let windr: String
    let neersl_perc_dag: Int
    let zond_perc_dag: Int
}

struct HourlyForecast: Codable, Identifiable {
    var id: UUID { UUID() }
    let uur: String
    let timestamp: Int
    let image: String
    let temp: Int
    let windbft: Int
    let windkmh: Int
    let windknp: Int
    let windms: Int
    let windrgr: Int
    let windr: String
    let neersl: Double
    let gr: Int
}
