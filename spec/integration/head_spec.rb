RSpec.describe "HTTP HEAD", type: :cli do
  it "returns empty body for HEAD requests" do
    with_project do
      generate "action web home#index --url=/"

      server do
        head '/'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to   eq("")
      end
    end
  end

  it "returns empty body for HEAD requests when body is set by the action" do
    with_project do
      generate "action web home#index --url=/"
      rewrite "apps/web/controllers/home/index.rb", <<-EOF
module Web
  module Controllers
    module Home
      class Index < Hanami::Action
        def call(*, res)
          res.body = "Hello"
        end
      end
    end
  end
end
EOF

      server do
        head '/'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to   eq("")
      end
    end
  end

  it "returns empty body for HEAD requests when body is set by the view" do
    with_project do
      generate "action web home#index --url=/"
      rewrite "apps/web/views/home/index.rb", <<-EOF
module Web::Views::Home
  class Index
    include Web::View

    def render
      "World"
    end
  end
end
EOF

      server do
        head '/'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to   eq("")
      end
    end
  end

  it "returns empty body for HEAD requests with send file" do
    with_project do
      write "public/static.txt", "Plain text file"
      generate "action web home#index --url=/"
      rewrite "apps/web/controllers/home/index.rb", <<-EOF
module Web
  module Controllers
    module Home
      class Index < Hanami::Action
        def call(*, res)
          res.send_file "static.txt"
        end
      end
    end
  end
end
EOF

      server do
        head '/'

        expect(last_response.status).to eq(200)
        expect(last_response.body).to   eq("")
      end
    end
  end
end
