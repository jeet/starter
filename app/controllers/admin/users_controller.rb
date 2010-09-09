class  Admin::UsersController < AdminController


  def index
    @search =   User.search(params[:search] )
    @users  = @search.paginate :page => params[:page], :per_page => params[:per_page] || 10
  end
end