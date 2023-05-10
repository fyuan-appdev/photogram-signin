class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new
    user.username = params.fetch("query_username")
    user.password = params.fetch("query_password")
    user.password_confirmation = params.fetch("query_password_confirmation")

    save_status = user.save

    if save_status == true
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", { :notice => "Welcome!"})
    else
      redirect_to("/user_sign_up", {:alert => user.errors.full_messages.to_sentence})
    end
  end

  def sign_out
    reset_session
    redirect_to("/", {:notice => "See you later!"})
  end

  def verification
    reset_session
    # get username from params
    login_name = params.fetch("query_username")
    # get password from params
    login_password = params.fetch("query_password")
    # look up the recrod from teh db matching username
    user = User.where({:username =>login_name }).at(0)
    # if there's no record, redirect back to sign in form
    if user == nil
      redirect_to("/user_sign_in", {:alert=>"No record found"})
    # if here is a recod, check password match
    else
      if user.authenticate(login_password) 
    # if yes, set the cookie
        session.store(:user_id, user.id)
    # and redirect to home page
        redirect_to("/" ,{:notice => "Welcome Back!" +user.username})
      else
    # if not, redirect back to sign in form
      redirect_to("/user_sign_in", {:alert=>"Password not match"})
      end
    end
    # render({:plain =>"123"})
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)

    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end


  def sign_in
  
    render({ :template => "users/user_sign_in.html.erb" })

  end

  def sign_up
  
    render({ :template => "users/user_sign_up.html.erb" })

  end
end
