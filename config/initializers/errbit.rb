if ENV['AIRBAKE_API_KEY']
  Airbrake.configure do |config|
    config.host = ENV['ERRBIT_ADRESS']
    config.project_id = 1
    config.project_key = ENV['AIRBAKE_API_KEY']
  end

  Airbrake.add_filter do |notice|
    notice[:context][:version] = '1.0.0'
  end
end
