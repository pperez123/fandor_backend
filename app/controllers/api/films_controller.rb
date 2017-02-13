class Api::FilmsController < ApplicationController
  before_action :check_fields_filter

  def index
    if params.has_key? :sort
      sort_by = params[:sort].split(',')
      sort_str = ''
      sort_by_rating = false

      sort_by.each do |sort_param|
        if sort_str.length > 0
          sort_str += ','
        end

        if sort_param =~ /title$/
          sort_str += 'title'
        end

        if sort_param =~ /description$/
          sort_str += 'description'

        end

        if sort_param =~ /year$/
          sort_str += 'year'
        end

        if sort_param =~ /average_rating$/
          sort_str += 'avg_rating'
          sort_by_rating = true
        end

        if sort_param =~ /^-/
          sort_str += ' DESC'
        end
      end

      if sort_by_rating
        @films = Film.find_by_sql('SELECT films.*, (SELECT max(avg(rating),0) FROM film_ratings WHERE film_id = films.id) as avg_rating FROM films ORDER BY ' + sort_str)
      else
        @films = Film.order(sort_str)
      end
    else
      @films = Film.all
    end
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
