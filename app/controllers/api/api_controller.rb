module Api
  class ApiController < ApplicationController
    include JSONAPI::ActsAsResourceController
    include JsonApiResourceController
  end
end
