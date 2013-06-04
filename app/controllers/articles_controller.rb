class ArticlesController < ApplicationController
  skip_before_filter :require_login, :only => [:index, :show]
  before_filter :check_my_article, :only => [:delete, :edit, :create]
  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  def my_articles
    @articles = Article.where(:user_id =>current_user.id)
    render :index
  end
  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])
    @user = User.find(@article.user_id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  def check_my_article
    format.html { redirect_to :article, notice: "Not allowed." } unless params[:user_id]=session[:user_id]
  end

  def vote
    if current_user && UserArticles.where(:articles_id=>params[:id], :user_id=>current_user.id).count==0
      UserArticles.create(:articles_id=>params[:id], :user_id=>current_user.id)
      @articles=Article.find(params[:id])
      @articles.update_attributes(:rating => @articles.rating + 1)
    end
    respond_to do |format|
      format.js do
        render :js => "$('#vote#{params[:id]}').css('visibility', 'hidden');$('##{params[:id]}').html(parseInt($('##{params[:id]}').html())+1);"
      end
    end
  end
end
