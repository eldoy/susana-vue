class UserController < ApplicationController

  # POST /api/user/create
  def create
    # Set up user
    @user = User.new(p)
    @user.password = p[:password]
    @user.confirm = p[:confirm]
    @user.salt = BCrypt::Engine.generate_salt
    @user.pw = BCrypt::Engine.hash_secret(@user.password, @user.salt)
    @user.token = Susana::Util.generate_token(:users)
    @user.validate_email = true
    @user.validate_password = true

    if @user.save(:validate => true)
      # Send hello email
      # mail.hello

      # Log in and redirect
      s[:user] = @user.token
      f[:info] = 'Welcome to Susana!'
      json(:status => 'ok', :code => 200, :messages => ['User created'], :result => {})
    else
      json(:status => 'error', :code => 422, :messages => ['Please correct the errors below'], :result => @user.errors)
    end
  end

  # GET /api/user/current
  def show
    @user = current_user
    json(:status => 'ok', :code => 200, :messages => ['User found'], :result => { :id => @user.id, :email => @user.email })
  end

  # POST /api/user/login
  def login
    # Check if user is in database
    @user = User.first(:email => p[:email])

    # Authenticate user
    if @user and @user.authenticate(p[:password])
      # Log in user
      s[:user] = @user.token
      f[:info] = 'Welcome back!'
      json(:status => 'ok', :code => 200, :messages => [], :result => {})
    else
      json(:status => 'error', :code => 422, :messages => ['Email and password combination not found'], :result => {})
    end
  end

  # GET /api/user/logout
  def logout
    s[:user] = nil
    json(:status => 'ok', :code => 200, :messages => ['You are now logged out'], :result => {})
  end

  # PUT /api/user/update
  def update

    # Fetch user
    @user = current_user
    @user.email = p[:email]
    @user.validate_email = true

    # Update user
    if @user.save(:validate => true)
      json(:status => 'ok', :code => 200, :messages => ['User updated'], :result => {})
    else
      json(:status => 'error', :code => 422, :messages => ['Please correct the errors below'], :result => @user.errors)
    end
  end

  # PUT /api/user/password
  def password

    # Fetch user
    @user = current_user

    # Set up password
    @user.password = p[:password]
    @user.confirm = p[:confirm]
    @user.current_password = p[:current_password]
    @user.pw = BCrypt::Engine.hash_secret(@user.password, @user.salt)
    @user.validate_password = true
    @user.validate_current_password = true

    # Save or display error
    if @user.save(:validate => true)
      json(:status => 'ok', :code => 200, :messages => ['Password updated'], :result => {})
    else
      json(:status => 'error', :code => 422, :messages => ['Please correct the errors below'], :result => @user.errors)
    end
  end

end
