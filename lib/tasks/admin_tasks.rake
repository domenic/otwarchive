namespace :admin do
  desc "Unsuspend suspended users who have been suspended_until up to 12 hours from now"
  task(:unsuspend_users => :environment) do
    User.update_all("suspended_until = NULL, suspended = false", ["suspended_until <= ?", 12.hours.from_now])
    puts "Users unsuspended."
  end
  
  desc "Resend sign-up notification emails after 24 hours"
  task(:resend_signup_emails => :environment) do
    @users = User.find(:all, :conditions => {:activated_at => nil, :created_at => 48.hours.ago..24.hours.ago})
    @users.each do |user|
      UserMailer.deliver_signup_notification(user)
    end
    puts "Sign-up notification emails resent"
  end
  
  desc "Purge unvalidated accounts created more than 48 hours ago"
  task(:purge_unvalidated_users => :environment) do
    User.destroy_all(["activated_at IS NULL AND created_at < ?", 48.hours.ago])
    puts "Unvalidated accounts created more than 48 hours ago have been purged"
  end
  
end