### Handling input errors

Right now our code has no logic for handling the situation when the user enters an incorrect password confirmation. It just fails silently, redirecting the user to the homepage. In the controller, the user.id will be nil because datamapper won't be able to save the record if the passwords don't match.

```ruby
  post '/users' do
    user = User.create(email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    # the user.id will be nil if the user wasn't saved
    # because of password mismatch
    session[:user_id] = user.id
    redirect to('/')
  end
```

Let's extend the test to expect a redirection back to the sign up form if the passwords don't match.

```ruby
  scenario 'with a password that does not match' do
    expect { sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content('Sorry, your passwords do not match')
  end
```

This test expects the website to stay at /users, instead of navigating to the home page (note the use of the current_path helper, provided by capybara). The reason is that we are submitting the form to /users and we don't want the redirection to happen if the user is not saved because we will lose the unsaved data.

Let's suppose we have a longer sign up form. A user fills out 20 fields but makes a mistake in password_confirmation. If we refresh the page by doing a redirect, we'll lose all information that was entered in the form because it was never saved to the database. This information only exists in memory, as properties of the invalid User model that is alive only for the duration of this request.

So, instead of redirecting the user, let's show the same form but this time we'll populate it using our invalid User object.

```ruby

post '/users' do
  # we just initialize the object
  # without saving it. It may be invalid
  user = User.new(email: params[:email],
                  password: params[:password],
                  password_confirmation: params[:password_confirmation])
  # let's try saving it
  # if the model is valid,
  # it will be saved
  if user.save
    session[:user_id] = user.id
    redirect to('/')
    # if it's not valid,
    # we'll show the same
    # form again
  else
    erb :'users/new'
  end
end
```

This is a fairly common pattern of handling potential errors. Instead of creating the object straight away, you initialise it, attempt to save and handle both possibilities.

However, how will the data (in our case the email the user entered) make its way from the user object to the re-rendered form? Let's make the user an instance variable and update the view.

```ruby
post '/users' do
  @user = User.new(email: params[:email],
                  password: params[:password],
                  password_confirmation: params[:password_confirmation])
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    erb :'users/new'
  end
end
```

```html
Email: <input name='email' type='text' value='<%= @user.email %>'>
```

Now the email will be part of the form when it's rendered again.

Because the view now expects @user instance variable, we must make sure that it's available in the /users/new route as well.

```ruby
get '/users/new' do
  @user = User.new
  erb :'users/new'
end
```

A new instance of the user will simply return nil for @user.email.

Finally, let's display a flash message at the top of the page which notifies the user of the error.

Begin by adding ```rack-flash3``` to the ```Gemfile```. Now add the flash line to ```server.rb```:

```ruby
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash[:notice] = 'Sorry, your passwords do not match'
    erb :'users/new'
  end
```

You'll need to make a couple more changes to the server file - see https://github.com/nakajima/rack-flash#sinatra for details.

Finally, add the following code to ```layout.erb``` allow the flash message to appear on the page.

```ruby
<% if flash[:notice] %>
  <div id='notice'><%= flash[:notice] %></div>
<% end %>
```

It will be displayed on top the page that was re-rendered (note the /users path).

![alt text](https://dchtm6r471mui.cloudfront.net/hackpad.com_jubMxdBrjni_p.52567_1380105990218_Screen%20Shot%202013-09-25%20at%2011.46.01.png "bookmark manager")


Finally, our tests pass.
```
Finished in 0.40513 seconds
7 examples, 0 failures
```
Current state is on Github
https://github.com/makersacademy/bookmark_manager/tree/bf1820c8e3ab276fae6e6d5be64cb2456451024c

[ [Next Stage](bookmark_manager_stage_5.md) ]

[ [Return to outline](bookmark_manager.md) ]