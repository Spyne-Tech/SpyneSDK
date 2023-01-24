
struct UserCreditRootClass : Codable {

    let data : UserCreditData?
    let message : String?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case message = "message"
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(UserCreditData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
}

struct UserCreditData : Codable {

    let creditAllotted : Int?
    let creditAvailable : Int?
    let creditUsed : Int?


    enum CodingKeys: String, CodingKey {
        case creditAllotted = "credit_allotted"
        case creditAvailable = "credit_available"
        case creditUsed = "credit_used"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        creditAllotted = try values.decodeIfPresent(Int.self, forKey: .creditAllotted)
        creditAvailable = try values.decodeIfPresent(Int.self, forKey: .creditAvailable)
        creditUsed = try values.decodeIfPresent(Int.self, forKey: .creditUsed)
    }


}
