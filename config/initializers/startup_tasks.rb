Rails.application.config.after_initialize do
  require 'rake'
  Rails.application.load_tasks

  begin
    Rake::Task['call_rail:fetch_and_save_all'].invoke
    Rake::Task['gravity_forms:fetch_and_save'].invoke
  rescue => e
    Rails.logger.error "Error running startup tasks: #{e.message}"
  end
end
