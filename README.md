# Finals Guide

1. Create a new app; gitignore; commit

    ```
    cp ../helps/.gitignore .
    ```

2. Create vendor scaffold; migrate; adjust index and edit; seeds.1.rb; faker; remove new vendor link on index; commit

    ```
    rails g scaffold vendor name:string phone:string email:string website:string address:string description:string content:text
    ```

    ```
    cp ../helps/seeds.1.rb db/seeds.rb 
    ```

3. Add search by keywords feature; controller; model; partial view; add highlights; commit

    ```
    <form method="get">
      <input name="keywords" value="<%= params[:keywords] %>" placeholder="keywo
      <button>Search</button>
    </form>
    ```


4. Create school resource; nest routes; root route; add school_id to vendors; seeds.2.rb; adjust school index; redirect on show; adjust vendor controller to load @school and load vendors from @school; adjust vendor index/show/edit links; commit

    ```
    rails g scaffold school name:string
    ```

    ```
    rails g migration add_school_id_to_vendor school_id:integer:index
    ```

    ```
    cp ../helps/seeds.2.rb db/seeds.rb 
    ```

    ```
    redirect_to school_vendors_path(@school)
    ```

    ```
    before_action :set_school, only: [:index]
    ```

    ```
    @school = School.find(params[:school_id]) if params[:school_id] 
    ```

    ```
    @vendors = @school.vendors
    ```

    ```
    <%= link_to 'Back', school_vendors_path(@school) %>
    ```

    ```
    <%= link_to 'Vendors', school_vendors_path(@vendor.school) %>
    ```

    ```
    <%= link_to 'School', schools_path %>
    ```

4. Add comment feature via scaffold; add association to vendor and comment; add index and form to vendor show; redirect create comment to vendor; hide vendor_id on form; commit

    ```
    rails g scaffold comment like:boolean content:string vendor_id:integer:index
    ```

    ```
    <% @vendor.comments.each do |comment| %>
    ```

    ```
    <%= render "comments/form", comment: @vendor.comments.new %>
    ```

5. Style page to add water.css; remove scaffold.css.scss; commit

    ```
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/kognise/water.css@latest/dist/light.min.css">
    ```

6. Clean up controllers; remove unnecessary actions; remove unnecessary formats; commit

7. Add pagination via pagy gem; include Pagy::Backend to vendors controller and Pagy::Frontend to application helper; load @pagy on vendors index action; set items to 5; update vendors index view; commit

    ```
    @pagy, @vendors = pagy(@vendors, items: 5)
    ```

    ```
    <%== pagy_info @pagy %>
    <%== pagy_nav @pagy %>
    ```

8. Add geosearch via geocoder; add config; add redis gem; update geocoder initializer with redis cache; add long lat to vendor model; add yaml_db gem; load data with long lat; update vendors controller with geo search via near; add location field on search box; commit

    ```
    rails generate geocoder:config
    ```

    ```
    cache: Rails.env.development?? Redis.new : nil,
    ```

    ```
    rails g migration add_long_lat_to_vendors longitude:float latitude:float
    ```

    ```
    rm db/seeds.rb
    ```

    ```
    rake db:reset
    ```

    ```
    cp ../helps/data.yml db/data.yml
    ```

    ```
    rake db:data:load
    ```

    ```
    <input name="location" value="<%= params[:location] %>" placeholder="locat
    ```

    ```
    @vendors = @vendors.near(params[:location], 100) if params[:location].present?
    ```

9. Add authentication via devise; setup config; update development.rb; generate user; add login links on top of page via application.html with a partial in app/views/application dir; separate flash messages into a partial in same dir; remove doubled flash messages from scaffold views; commit

    ```
    rails generate devise:install
    ```

    ```
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    ```

    ```
    rails generate devise user
    ```

    ```
    <%= render "messages" %>
    ```

    ```
    <%= render "login" %>
    ```

    ```
    <% if user_signed_in? %>
      <%= link_to "Sign out", destroy_user_session_path, method: :delete %>
      <%= current_user.email %>
    else %>
      <%= link_to "Home", root_path %> |
      <%= link_to "Sign in", new_user_session_path %>
      <%= link_to "Sign up", new_user_registration_path %>
    <% end %>
    ```

    ```
    <% flash.each do |type, msg| %>
      <p><%= msg %></p>
    <% end %>
    ```

10. Add claim vendor feature; add user_id to vendor and add association on model; add claim action on vendor controller; add claim action on routes; add claim button; commit

    ```
    rails g migration add_user_id_to_vendor user_id:integer:index
    ```

    ```
    def claim
      if @vendor.update(user: current_user)
        redirect_to @vendor, notice: 'Vendor was successfully claimed.'
      else
        render :show
      end
    end
    ```

    ```
    resources :vendors do
      get :claim, on: :member
    end
    ```

    ```
    <%= link_to 'Claim', claim_vendor_path(@vendor) if user_signed_in? %> |
    ```

11. Add authorization via cancancan; generate ability class; add permission rules to allow reading everything by everyone except vendor edit--only allowed by user who owns vendor; update vendors controller to use load_and_authorize_resource; commit

    ```
    rails g cancan:ability
    ```

    ```
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end
    ```

12. Add mail to vendor on comment create; commit

    ```
    rails generate mailer comments_mailer
    ```

    ```
    def notify_vendor(vendor)
      @vendor = vendor
      mail to: @vendor.email, subject: "You received a comment!"
    end
    ```

    ```
    CommentsMailer.notify_vendor(@comment.vendor).deliver_now if Rails.env.development?
    ```

13. Add icons via fontawesome; update vendor likes to icons; commit

    ```
    <script src="https://kit.fontawesome.com/0d41050561.js"></script>
    ```

    ```
    <% if comment.like %>
      <i class="fa fa-heart" style="color:red;"></i>
    <% else %>
      <i class="fa fa-heart-broken" style="color:#ccc;"></i>
    <% end %>
    ```

14. Deploy to Heroku; run data load

    ```
    git push heroku master
    ```

    ```
    heroku run rake db:reset
    ```

    ```
    heroku run rake db:data:load
    ```

