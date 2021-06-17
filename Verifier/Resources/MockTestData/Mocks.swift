import Foundation

struct Mocks {
    
    static var updateKey: String {
        Bundle.main.infoForKey("baseUrl")! + Bundle.main.infoForKey("updateEndpoint")!
    }
    
    static var statusKey: String {
        Bundle.main.infoForKey("baseUrl")! + Bundle.main.infoForKey("statusEndpoint")!
    }
    
    static var settingsKey: String {
        Bundle.main.infoForKey("baseUrl")! + Bundle.main.infoForKey("settingsEndpoint")!
    }
    
    static var mocks: [String: String] {
        [Mocks.updateKey: "MIIEFzCCAf8CAhI8MA0GCSqGSIb3DQEBBAUAMIGDMQswCQYDVQQGEwJYWDEaMBgGA1UECAwRRXVyb3BlYW4gQ29tbWlzb24xETAPBgNVBAcMCEJydXNzZWxzMQ4wDAYDVQQKDAVESUdJVDEUMBIGA1UECwwLUGVuIFRlc3RpbmcxHzAdBgNVBAMMFlBlbiBUZXN0ZXJzIEFDQyAoQ1NDQSkwHhcNMjEwNTA3MTM0MTE0WhcNMjIwNTA3MTM0MTE0WjAeMQswCQYDVQQGEwJYWDEPMA0GA1UEAwwGUm9iZXJ0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqrScBZXVoF4+UcbE8+eRVMsDjvdA9CvxE+f077zYJ6/xaVzNooafTvWI/QHCxNKT8diNoo1uylhvbvCY1sWsjPwCFkTJE49LGm5IetPRHX9zKTsd+fyMj2+yQxx3tkj6d9jO6hmozJhjxSMGvV0IyXIv3fsXHH3kOHpT43mf9MxFBYua4Qxci0RgGYCIJSwZk9jiHRKAFFiDf5hMcqmcezzcMDJc17FhJ7TenqbtzVfr3L9yzZLURqDylVeOit/w5PGyN+KhJRGjPqReqreaFGQsviy3VVf0wKfKMOovHobj7+DYBpyXFuUKE6u0P+3NQfnwwzt6bxLasHwhSmwCCwIDAQABMA0GCSqGSIb3DQEBBAUAA4ICAQBiKvNcpS9aVn58UbUgRLNgOkjhzd5qby/s0bV1XHT7te7rmfoPeB1wypP4XMt6Sfz1hiQcBGTnpbox4/HPkHHGgpJ5RFdFeCUYj4oqIB+MWOqpnQxKIu2f4a2TqgoW2zdvxk9eO9kdoTbxU4xQn/Y6/Wovw29B9nCiMRwa39ZGScDRMQMTbesd/6lJYtSZyjNls2Guxv4kCy3ekFktXQzsUXIrm+Yvhe68+dPgKe26S1xLNRt3kAR30HM5kB3vM8jTGiqubOe6W6YfcX4XoVfmwVfttk2BLPl0u/SXt/SsRHWuYzJ48AUXkK6vd3HR5FG39YSvEZ1Tlf9GRmR2uXO/TnnZiGd+cyjLgAPGtjg1oq0MdzlIFsoFe9cN/XVGjkmRYZ7FzdiSn6IQWUyyoGmFN5B7Q6ZdBMAb58Z3jcTwzmkkHZlfqpUSoK+Hpah515SgjwfY5s9g8vEqefWVmLlYGAiDkfaTYUie53wCXBC+xBJBL7VJnaxqmTKWwM5cRx5uZyOUs6ZQT7CKD1SDk1+C7PAevGKNFTatFn4puITVgQ0NFiIf7ZKOy1w8Zf5aVk0vP3gfOg3SK38RgD81iLTPWr07XTfMZBTaTUr+ph6hxtwSIhHVFsF6n8adl5RynuYDfCCts5E9mOGLqC7ruMKRoOIBOPEwGS5/wIhMO7UEgQ==",
         Mocks.statusKey: "[\"+/bbaA9m0j0=\"]",
         Mocks.settingsKey: try! String(contentsOfFile: Bundle.main.path(forResource: "settings", ofType: "json")!)]
    }
    
    private static var mockHeaders: [String: [String: String]] {
        [Mocks.updateKey: ["X-KID": "+/bbaA9m0j0=",
                            "X-RESUME-TOKEN": "1"]]
    }
    
    static func data(for request: URLRequest ) -> Data? {
        guard let key = request.url?.absoluteString else {
            return nil
        }
        
        // Extra rule for resume token
        if key == Mocks.updateKey && request.headers["x-resume-token"] == "1" {
            return nil
        }
        
        guard let loadJSON = Mocks.mocks[key] else {
            return nil
        }
        
        return loadJSON.data(using: String.Encoding.utf8)
    }
    
    static func headers(for request: URLRequest ) -> [String: String]? {
        guard let key = request.url?.absoluteString else {
            return nil
        }
        
        return Mocks.mockHeaders[key]
    }
}

