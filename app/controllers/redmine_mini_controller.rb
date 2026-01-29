class RedmineMiniController < ApplicationController

  def toggle
    # Toggle the setting
    if User.current.pref[:redmine_mini_disabled] == 'true'
      User.current.pref[:redmine_mini_disabled] = 'false'
    else
      User.current.pref[:redmine_mini_disabled] = 'true'
    end
    
    User.current.pref.save

    # Redirect back to the page the user came from
    redirect_back_or_default(home_path)
  end
end
