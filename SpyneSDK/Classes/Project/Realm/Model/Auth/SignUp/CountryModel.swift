import Foundation

struct CountryModel : Codable {

    let data : [CountryData]?
    let message : String?
    let status : Int?


    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([CountryData].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }

}

struct CountryData : Codable {

    let id : Int?
    let isdCode : String?
    let name : String?
    let numLength : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case isdCode = "isd_code"
        case name = "name"
        case numLength = "num_length"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        isdCode = try values.decodeIfPresent(String.self, forKey: .isdCode)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        numLength = try values.decodeIfPresent(String.self, forKey: .numLength)
    }


}
