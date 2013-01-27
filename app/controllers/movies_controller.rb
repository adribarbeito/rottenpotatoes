class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if params[:sort].nil? && params[:ratings].nil? &&
        (!session[:sort].nil? || !session[:ratings].nil?)
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end

    @hash_ratings = params[:ratings]
    if @hash_ratings.nil?
      @selected_ratings = Movie.ratings
    else
      @selected_ratings = Array.new
      @hash_ratings.each do |key, value|
        if value == "1" or value == "true"
          @selected_ratings << key
        end
      end
      puts @selected_ratings.to_s
    end

    @sort = params[:sort]


    @all_ratings = Movie.ratings.inject(Hash.new) do |all_ratings, rating|
      all_ratings[rating] = @selected_ratings.nil? ? false : @selected_ratings.include?(rating) 
      all_ratings
    end

    if @selected_ratings.nil?
      if @sort.nil?
        @movies = Movie.all
      else
        @movies = Movie.order("#{@sort} ASC")
      end
    else
      if @sort.nil?
        @movies = Movie.find_all_by_rating(@selected_ratings)
      else
        @movies = Movie.order("#{@sort} ASC").find_all_by_rating(@selected_ratings)
      end
    end

    session[:sort] = @sort
    session[:ratings] = @hash_ratings

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
