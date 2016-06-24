import S4

extension Response {
    mutating func setCookies(cookies: Cookies){
        self.cookies = cookies.toSet()
    }
}
