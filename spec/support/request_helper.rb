module Request
  module HeadersHelpers
    def api_authorization_header(token)
      # get token(Bingqian)
      request.headers['Authorization'] =  token
    end
  end
  module JsonHelpers
    def json_response
      @json_response = JSON.parse(response.body, symbolize_names: true)
    end
  end
end