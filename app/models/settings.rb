# wrapper for application config accessible through Settings object
# TODO possibly make this an initializer? look into Settingslogic documentation
class Settings < Settingslogic
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env
end
