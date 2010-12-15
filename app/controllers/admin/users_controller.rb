class  Admin::UsersController < AdminController


  def index
    @search =   User.search(params[:search] )
    @users  = @search.paginate :page => params[:page], :per_page => params[:per_page] || 10
  end

  def new
      @user = User.new
    end

    def create
      @user = User.new(params[:user])
      @user.active = true
       if @user.save
        flash[:notice] = "Your account has been created"
         redirect_to admin_user_path(@user)
      else
        render :action => :new
      end
    end


   def show
      @user = User.find(params[:id])
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
       if @user.update_attributes(params[:user])
        flash[:notice] = "Account updated!"
        redirect_to admin_user_path(@user)
      else
        render :action => :edit
      end
    end

   


end