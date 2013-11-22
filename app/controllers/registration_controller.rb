class RegistrationController < Devise::RegistrationsController

	def create
    if request.referer.to_s.downcase.include? "vinny"
      campaign = request.referer.split('.com/').last
    else
      campaign = "other"
    end
    if params["user"] && params["user"]["age"]
      age = params["user"]["age"]
    end
    if params["xxTrustedFormCertUrl"]
      trusted = params["xxTrustedFormCertUrl"]
    else
      trusted = ""
    end
    @user = User.create(:ip => request.remote_ip, :campaign => campaign, :age => age, :trusted => trusted)
    sign_in @user
    respond_to do |format|
      format.html { redirect_to '/'}
      format.js
    end
  end
    

end
