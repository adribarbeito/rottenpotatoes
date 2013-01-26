class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @hash_ratings = params[:ratings]
    if !@hash_ratings.nil?
      @selected_ratings = @hash_ratings.keys
    end

    @all_ratings = Movie.ratings

    @sort = params[:sort]
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
        @movies = Movie.find_all_by_rating(@selected_ratings).order("#{@sort} ASC")
      end
    end

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
