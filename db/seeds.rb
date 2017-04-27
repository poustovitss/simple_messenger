User.where(email: 'admin@admin.com').first_or_create do |user|
  user.first_name            = 'Main'
  user.last_name             = 'Admin'
  user.role                  = :admin
  user.password              = 'changemeadmin'
  user.password_confirmation = 'changemeadmin'
end
