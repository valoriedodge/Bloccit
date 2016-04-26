class Api::V1::PostsController < Api::V1::BaseController
    before_action :authenticate_user, except: [:index, :show]
    before_action :authorize_user, except: [:index, :show]
    
    def index
        posts = Post.all
        render json: posts, status: 200
    end
    
    def show
        post = Post.find(params[:id])
        response = {:post => post, :comments => post.comments}
        render json: response, status: 200
    end
end