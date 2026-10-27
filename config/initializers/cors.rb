
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "https://andresberriosl.github.io",
            "http://localhost:5500"

    resource "/api/v1/services",
             headers: :any,
             methods: [:get]

    resource "/api/v1/services/*",
             headers: :any,
             methods: [:get]
  end
end
