import HTTP

class Cookies {
    private var cookies = Dictionary<String, AttributedCookie>()
    
    subscript(name: String) -> String? {
        get {
            return cookies[name]?.value
        }
        set(newValue){
            guard let newValue = newValue else {
                return
            }
            let cookie = AttributedCookie(name: name, value: newValue)
            cookies[name] = cookie
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
