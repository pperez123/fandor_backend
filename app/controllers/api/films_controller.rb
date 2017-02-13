class Api::FilmsController < ApplicationController
  before_action :check_fields_filter

  def index
    @films = Film.all
  end

  def show
    @film = Film.find(params[:id])
  end

  def update
    film_to_update = Film.find(params[:id])
    attributes = params[:data][:attributes]

    if film_to_update
      if attributes.has_key?(:rating)
        if !attributes.has_key?(:user_id)
          render :json => {:data => {:error => {:description => 'No user id for rating.'}}}, :status => :not_acceptable
        else
          film_to_update.set_rating_for_user(attributes[:user_id], attributes[:rating])
          render :json => {:data => {:status => 'Success'}}, :status => :ok
        end
      else
        render :json => {:data => {:error => {:description => 'Film not found.'}}}, :status => :not_found
      end
    end
  end

  def check_fields_filter
    @fields_to_display = Array.new

    # Check for fields to display only
    if params.has_key?(:fields) && params[:fields].has_key?(:film)
      @fields_to_display = params[:fields][:film].split(',')
    end
  end
end
