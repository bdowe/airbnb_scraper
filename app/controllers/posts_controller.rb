class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def home
    @housing_types = []
    Post.all.each do |post|
      @housing_types << post.housing
    end
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.paginate(:page => params[:page], :per_page => 30)
    @posts = @posts.where(beds: params["beds"]) if params["beds"].present?
    @posts = @posts.where("price >= ?", params["min_price"]) if params["min_price"].present?
    @posts = @posts.where("price <= ?", params["max_price"]) if params["max_price"].present?
    #consider moving this so it doesn't run every time index runs
    @housing_types = []
    Post.all.each do |post|
      @housing_types << post.housing
    end
    @housing_types.uniq!
    @posts = @posts.where(housing: params["housing"]) if params["housing"].present?
    @posts = @posts.where(reviews: params["reviews"]) if params["reviews"].present?
    @posts = @posts.where("reviews > ?", params["min_reviews"]) if params["min_reviews"].present?
    @posts = @posts.where("reviews < ?", params["max_reviews"]) if params["max_reviews"].present?
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:heading, :price, :housing, :beds, :reviews, :timestamp)
    end
end
