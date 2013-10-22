class UsersController < ApplicationController
  before_filter :authorize, :except => [:new, :create, :edit, :update, :results, :extra_info, :extra_info_2, :checkzip, :csvi]

  require 'mechanize'
  require 'geokit'
  require 'area'

  # GET /users
  # GET /users.json
  def index
    @users = User.all.sort

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # def csvi
  #   @users = User.first(10)
  #     send_data User.to_csv
  # end

  def results
    @users = User.all.sort
  end

  # def checkzip
  #   # geo = GeoKit::Geocoders::MultiGeocoder.multi_geocoder(params["zipcode"])
  #   #   if geo.success
  #   #     render json: "yes".to_json
  #   #   else
  #   #     render json: "no".to_json
  #   #   end

  #   if params["zipcode"].length == 5 && params["zipcode"].to_region != nil
  #     render json: "yes".to_json
  #   else
  #     render json: "no".to_json
  #   end

  # end

  def extra_info
    if current_user
      @user = current_user
    else
      redirect_to root_path
    end
  end

  def extra_info_2
    if current_user
      @user = current_user
    else
      redirect_to root_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if params["zipcode"]
      @user.zipcode = params["zipcode"]
      @user.save!
    end
    if params["age"]
      @user.age = params["age"]
      @user.save!
    end
    if params["employment"]
      @user.employment = params["employment"]
      @user.save!
    end
    if params["medical"]
      @user.medical = params["medical"]
      @user.save!
    end
    if params["attorney"]
      @user.attorney = params["attorney"]
      @user.save!
    end
    if params["previous"]
      @user.previous = params["previous"]
      @user.save!
    end
    if params["desc"]
      @user.desc = params["desc"]
      @user.save!
    end
    if params["name"]
      @user.name = params["name"]
      @user.save!
    end
    if params["phone"]
      @user.phone = params["phone"]
      @user.save!
    end
    if params["email"]
      @user.email = params["email"]
      @user.save!
    end
    if params["consent"]
      @user.consent = params["consent"]
      @user.save!
    end
    if params["debt"]
      @user.debt = params["debt"]
      @user.save!
    end
    if params["loan"]
      @user.debt = params["loan"]
      @user.save!
    end
      if @user.update_attributes(params[:user])
        if @user.phone && @user.email && @user.name && @user.zipcode && @user.age.to_i >= 30 && @user.employment == "Making less than $1500 per month" && @user.attorney == "No" && @user.medical == "Yes"
          @user.qualified = true
          @user.save!
            a = Mechanize.new
            geo = GeoKit::Geocoders::MultiGeocoder.multi_geocoder(@user.zipcode)
            if geo.success
              state = geo.state
            else
              state = ""
            end
            if @user.campaign.to_s.downcase.include? "vinny"
              lead_src = "PUJ"
            elsif @user.campaign == "other"
              lead_src = "REV"
            else
              lead_src = "RAW"
            end
              url = "https://leads.leadtracksystem.com/genericPostlead.php"
              params = {
                "TYPE" => '85',
                "SRC" => "PujiiComp1",
                "Trusted_Form" => @user.trusted,
                "Landing_Page" => "amp1",
                "IP_Address" => "75.2.92.149",
                "First_Name" => @user.name.split(' ')[0],
                "Last_Name" => @user.name.split(' ')[1],
                "State" => state,
                "Zip" => @user.zipcode,
                "Email" => @user.email,
                "Day_Phone" => @user.phone,
                "Evening_Phone" => @user.phone,
                "Age" => @user.age,
                "Employment_Status" => @user.employment,
                "Medical_Status" => @user.medical,
                "Representation_Status" => @user.attorney,
                "Previously_Applied" => @user.previous,
                "Unsecured Debt" => "No, I do not need help",
                "Student Loans" => "No, I do not need student debt help",
                "Description" => @user.desc,
                "Pub_ID" => lead_src
              }
              response = a.post(url, params)
              puts d = Nokogiri::XML(response.content)
              @user.lead = d.xpath("//lead_id").text
              @user.save!
          redirect_to '/logout'
        elsif @user.phone && @user.qualified == nil
          @user.qualified = false
          @user.save!
          redirect_to '/extrainfo1'
        elsif @user.phone && @user.qualified == false && @user.loan == nil
          redirect_to '/extrainfo2'
        elsif @user.phone && @user.loan != nil && @user.debt != nil
            a = Mechanize.new
            geo = GeoKit::Geocoders::MultiGeocoder.multi_geocoder(@user.zipcode)
            if geo.success
              state = geo.state
            else
              state = ""
            end
              if @user.campaign.to_s.downcase.include? "vinny"
                lead_src = "PUJ"
              elsif @user.campaign == "other"
                lead_src = "REV"
              else
                lead_src = "RAW"
              end
              url = "https://leads.leadtracksystem.com/genericPostlead.php"
              params = {
                "TYPE" => '85',
                "SRC" => "PujiiComp1",
                "Trusted_Form" => @user.trusted,
                "Landing_Page" => "amp1",
                "IP_Address" => "75.2.92.149",
                "First_Name" => @user.name.split(' ')[0],
                "Last_Name" => @user.name.split(' ')[1],
                "State" => state,
                "Zip" => @user.zipcode,
                "Email" => @user.email,
                "Day_Phone" => @user.phone,
                "Evening_Phone" => @user.phone,
                "Age" => @user.age,
                "Employment_Status" => @user.employment,
                "Medical_Status" => @user.medical,
                "Representation_Status" => @user.attorney,
                "Previously_Applied" => @user.previous,
                "Unsecured Debt" => @user.debt,
                "Student Loans" => @user.loan,
                "Description" => @user.desc,
                "Pub_ID" => lead_src
              }
              response = a.post(url, params)
              puts d = Nokogiri::XML(response.content)
              @user.lead = d.xpath("//lead_id").text
              @user.save!
          redirect_to '/logout'
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
