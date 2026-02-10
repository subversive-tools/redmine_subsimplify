class RedmineSubsimplifyController < ApplicationController
  def toggle
    if User.current.pref[:redmine_subsimplify_disabled] == 'true'
      User.current.pref[:redmine_subsimplify_disabled] = 'false'
    else
      User.current.pref[:redmine_subsimplify_disabled] = 'true'
    end
    User.current.pref.save
    redirect_back_or_default(home_path)
  end
end
