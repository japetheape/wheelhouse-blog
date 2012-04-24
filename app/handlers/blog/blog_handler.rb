class Blog::BlogHandler < Wheelhouse::ResourceHandler
  get :cache => true do
    I18n.locale = :nl
    # Nothing extra required
    @posts = @blog.posts
  end

  get "/feed.xml", :cache => true do
    request.format = :xml
    render :template => "feed.xml", :layout => false
  end
  
  get '/author/:author', :cache => true do
    @posts = @blog.posts.by_author(params[:author])

    render :template => "index.html"
  end

  get '/tag/:tag', :cache => true do
    @posts = @blog.posts.tagged_with(params[:tag])
    render :template => "tag.html"
  end
  
  get '/category/:category', :cache => true do
    @posts = @blog.posts.in_category(params[:category])
    render :template => "category.html"
  end
  
  get "/:year/:month/:permalink", :cache => true do
    @post = @blog.find_post(params[:year], params[:month], params[:permalink])
    render @post
  end
  
  get "/:year/:month", :cache => true do
    @year  = params[:year].to_i
    @month = params[:month].to_i
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}" if @year.zero? || @month.zero?
    
    @posts = @blog.posts.in_year_and_month(@year, @month)
    render :template => "archive.html"
  end
end
