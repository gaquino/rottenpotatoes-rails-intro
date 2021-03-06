class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    session_params = session.to_hash.slice('sort','ratings')
    if params.slice(:sort, :ratings).empty? && session_params.any?
      flash.keep
      redirect_to movies_path(session_params)
    end
    
    
    @all_ratings = ['G','PG','PG-13','R']
    
    @ratingValue = params[:ratings]
    puts  "RATING==>" + @ratingValue.to_s
    puts "RATINGS" + (!@ratingValue.nil?).to_s
    
    
    
    if(!@ratingValue.nil?)
      puts "loop"
      @ratingValue.keys.each do |mykey|
        puts "KEY=>" + mykey
      end
    else
      if(session[:ratings].present?)
        @ratingValue =session[:ratings]
      else
        @ratingValue = {"G"=>"G","PG"=>"PG","PG-13"=>"PG-13","R"=>"R"}
      end
    end
    
    @sortdata = params[:sort]
    
    #session[:sort] = params[:sort] if params[:sort].present?
    #session[:ratings] = params[:ratings] if params[:sort].present?
    
    #params[:sort].present? ? session[:sort] = params[:sort] : nil
    #params[:ratings].present? ? session[:ratings] = params[:ratings] : session[:ratings] = @ratingValue unless session[:ratings].present?
    
    session[:ratings] = params[:ratings] if params[:ratings].present?
    session[:sort] = params[:sort] if params[:sort].present?
    
    puts "SESSION_SORT" + session[:sort].to_s
    puts "SESSION_RTING" + session[:ratings].to_s
    
    
    if @sortdata == 'title'
      @title_header = 'hilite'
    elsif @sortdata == 'release_date'
      @release_date_header = 'hilite'
    end
    
    #@movies = Movie.all
    if(!@ratingValue.nil?)
      puts "FILTRO POR RATING"
      @movies = Movie.order(session[:sort]).where(:rating => @ratingValue.keys)
    else
      puts "FILTRO POR ORDER"
      @movies = Movie.order(session[:sort])
    end
  
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
