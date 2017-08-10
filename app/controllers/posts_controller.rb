class PostsController < ApplicationController
	before_action :find_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
	before_action :authenticate_user!, except: [:index, :show]

	
	def index
	  @posts = Post.paginate(:page => params[:page], :per_page => 9)
	end

	def show 
	  @comments = Comment.where(post_id: @post)
	  @random_post = Post.where.not(id: @post).order("RANDOM()").first 
	end 

	def new
	  @post = current_user.posts.build 
	end

	def create
	  @post = current_user.posts.build(post_params)

	  if @post.save 
	    redirect_to @post 
	  else 
		render 'new'
	  end 
	end  

	def edit
	  #@post = Post.edit(post_params)
	end 

	def update 
	  if @post.update(post_params)
	  	redirect_to @post 
	  else 
	  	render "edit"
	  end 
	end 

	def destroy 
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Link was successfully destroyed.' }
        format.json { head :no_content }
      end
	end 

	def upvote
      @post = Post.find(params[:id])
      @post.upvote_by current_user
      redirect_to request.referrer  
    end

    def downvote
      @post = Post.find(params[:id])
      @post.downvote_by current_user
      redirect_to request.referrer   
    end 

	private 

	  def find_post
	  	@post = Post.find(params[:id]) 
	  end 

	  def post_params
	  	params.require(:post).permit(:title, :link, :description, :image)
	  end 
end
