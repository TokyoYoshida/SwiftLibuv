import HTTP

class Cookies {
    private var cookies = Dictionary<String, AttributedCookie>()
    
    subscript(name: String) -> AttributedCookie? {
        get {
            return cookies[name]
        }
        set(newValue){
            guard var newValue = newValue else {
                return
            }
            newValue.name = name
            cookies[name] = newValue
        }
    }

    func toSet() -> Set<AttributedCookie>{
        var retValue = Set<AttributedCookie>()
        
        cookies.forEach {
            retValue.insert($0.1)
        }

        return retValue
    }
}
