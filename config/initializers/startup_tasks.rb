Rails.application.config.after_initialize do
  require 'rake'
  Rails.application.load_tasks

  begin
    Rails.logger.info "Invoking Rake task: call_rail:fetch_and_save_all"
    Rake::Task['call_rail:fetch_and_save_all'].invoke
    Rails.logger.info "Successfully invoked Rake task: call_rail:fetch_and_save_all"
    
    Rails.logger.info "Invoking Rake task: gravity_forms:fetch_and_save"
    Rake::Task['gravity_forms:fetch_and_save'].invoke
    Rails.logger.info "Successfully invoked Rake task: gravity_forms:fetch_and_save"
  rescue => e
    Rails.logger.error "Error running startup tasks: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end
end
