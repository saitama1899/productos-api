class ApplicationController < ActionController::API
    # Include helpers file to application_controller.rb so our controller will know it
    include Response
    include ExceptionHandler
end
