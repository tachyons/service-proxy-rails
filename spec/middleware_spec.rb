require 'rails_helper'


RSpec.describe Service::Proxy::Middleware do
  let(:app) { lambda {|_| [200, {'Content-Type' => 'text/plain'}, ['OK']]} }

  subject { describe.new(app) }


end