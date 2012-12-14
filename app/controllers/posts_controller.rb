class PostsController < ApplicationController
    # GET /posts
    # GET /posts.json
    def index
        @page = params[:page]
        retry_var = params[:retry]

        @top=params[:top]
        @top = @top.to_i()
        
        retry_var = retry_var.to_i()
        @page = @page.to_i()

        if @page == 0
            @page = 1
        end
        
        @post = Post.new
        post_per_page = 10

        if @top != 1
            @posts = Post.find(:all, :limit => post_per_page, :offset => post_per_page *(@page - 1), :conditions => {:approved => true}, :order=>'created_at DESC')
        else
            @posts = Post.find(:all, :limit => post_per_page, :offset => post_per_page *(@page - 1), :conditions => {:approved => true}, :order=>'(likes + dislikes) DESC')
        end


        @next_page = @page + 1
        @previous_page = @page - 1

        if @posts.length == 0 && retry_var != 1
            redirect_to posts_path({:page => 1, :retry => 1})
            return    
        end

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @posts }
        end
    end

    # GET /posts/1
    # GET /posts/1.json
    def show
        @post = Post.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @post }
        end
    end

    # GET /posts/new
    # GET /posts/new.json
    def new
        @post = Post.new

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @post }
        end
    end

    # GET /posts/1/edit
    def edit
        @post = Post.find(params[:id])
    end

    # POST /posts
    # POST /posts.json
    def create
        @post = Post.new(params[:post])

        respond_to do |format|
            if @post.save
                format.html { redirect_to posts_thankyou_path, notice: 'Post was successfully created.' }
                format.json { render json: @post, status: :created, location: @post }
            else
                format.html { render action: "new" }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
        end
    end

    # PUT /posts/1
    # PUT /posts/1.json
    def update
        @post = Post.find(params[:id])

        respond_to do |format|
            if @post.update_attributes(params[:post])
                format.html { redirect_to posts_approve_path, notice: 'Post was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /posts/1
    # DELETE /posts/1.json
    def destroy
        @post = Post.find(params[:id])
        @post.destroy

        respond_to do |format|
            format.html { redirect_to (:back) }
            format.json { head :no_content }
        end
    end

    # PUT like_post_path
    # /posts/:id/like
    

    def like
        @post = Post.find(params[:id])
        @post.update_attributes(:likes => @post.likes + 1)
        store_in_session(params[:id], "like")
        redirect_to(:back)
    end


    # PUT dislike_post_path
    # /posts/:id/dislike
    def dislike
        @post = Post.find(params[:id])
        @post.update_attributes(:dislikes => @post.dislikes + 1)
        store_in_session(params[:id], "dislike")
        redirect_to(:back)
    end

    # GET posts_approve_path
    # /posts/approve
    def approve
        @posts = Post.find(:all, :conditions => {:approved => false}, :order=>'created_at DESC')
    end

    def delete
        @posts = Post.find(:all, :conditions => {:approved => true}, :order=>'created_at DESC')
    end

    # PUT approve_post_post_path
    # /posts/:id/approve_post
    def approve_post
        @post = Post.find(params[:id])
        @post.update_attributes(:approved => 1)
        redirect_to posts_approve_path
    end

    # GET posts_thankyou
    # /posts/thankyou
    def thankyou
    end

    private

    def store_in_session(id, action)
        liked_posts[id] = action
    end

end
