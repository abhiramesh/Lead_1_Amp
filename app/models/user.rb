class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :zipcode, :home_value, :mortgage_balance, :name, :email, :phone, :age, :employment, :attorney, :medical, :lead, :ip, :campaign, :debt, :loan, :previous, :desc, :trusted, :consent

  require 'mechanize'
  require 'geokit'
  require 'area'

  # def self.to_csv
  #   CSV.generate(col_sep: "\t") do |csv|
  #     csv << ["Name", "Email", "Phone", "Campaign"]
  #     all.each do |user|
  #     	row = []
  #       row << user.name
  #       row << user.email
  #       row << user.phone
  #       row << user.campaign
  #       csv << row
  #     end
  #   end
  # end

  def send_lead
    unless self.previous == "Yes, receiving benefits"
          a = Mechanize.new
            # begin
            # state = self.zipcode.to_region(state: true)
            # rescue
             state = ""
            # end
            if self.campaign.to_s.downcase.include? "vinny"
              lead_src = "PUJ"
            elsif self.campaign == "other"
              lead_src = "REV"
            else
              lead_src = "RAW"
            end
              url = "https://leads.leadtracksystem.com/genericPostlead.php"
              params = {
                "TYPE" => '85',
                "SRC" => "PujiiComp1",
                "Trusted_Form" => self.trusted,
                "Landing_Page" => "amp1",
                "IP_Address" => self.ip,
                "First_Name" => self.name.split(' ')[0],
                "Last_Name" => self.name.split(' ')[1],
                "State" => state,
                "Zip" => self.zipcode,
                "Email" => self.email,
                "Day_Phone" => self.phone,
                "Evening_Phone" => self.phone,
                "Age" => self.age,
                "Employment_Status" => self.employment,
                "Medical_Status" => self.medical,
                "Representation_Status" => self.attorney,
                "Previously_Applied" => self.previous,
                "Unsecured Debt" => "No, I do not need help",
                "Student Loans" => "No, I do not need student debt help",
                "Description" => self.desc,
                "Pub_ID" => lead_src
              }
              response = a.post(url, params)
              puts d = Nokogiri::XML(response.content)
              self.lead = d.xpath("//lead_id").text
              self.save!
    end
  end


  def send_lead_2
    unless self.previous == "Yes, receiving benefits"
    a = Mechanize.new
            # geo = GeoKit::Geocoders::MultiGeocoder.multi_geocoder(self.zipcode)
            # if geo.success
            #   state = geo.state
            # else
              state = ""
            # end
              if self.campaign.to_s.downcase.include? "vinny"
                lead_src = "PUJ"
              elsif self.campaign == "other"
                lead_src = "REV"
              else
                lead_src = "RAW"
              end
              url = "https://leads.leadtracksystem.com/genericPostlead.php"
              params = {
                "TYPE" => '85',
                "SRC" => "PujiiComp1",
                "Trusted_Form" => self.trusted,
                "Landing_Page" => "amp1",
                "IP_Address" => self.ip,
                "First_Name" => self.name.split(' ')[0],
                "Last_Name" => self.name.split(' ')[1],
                "State" => state,
                "Zip" => self.zipcode,
                "Email" => self.email,
                "Day_Phone" => self.phone,
                "Evening_Phone" => self.phone,
                "Age" => self.age,
                "Employment_Status" => self.employment,
                "Medical_Status" => self.medical,
                "Representation_Status" => self.attorney,
                "Previously_Applied" => self.previous,
                "Unsecured Debt" => self.debt,
                "Student Loans" => self.loan,
                "Description" => self.desc,
                "Pub_ID" => lead_src
              }
              response = a.post(url, params)
              puts d = Nokogiri::XML(response.content)
              self.lead = d.xpath("//lead_id").text
              self.save!
    end
  end


end
