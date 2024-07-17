Rails.application.config.after_initialize do
  require 'rake'
  Rails.application.load_tasks
  Rake::Task['call_rail:fetch_and_save_all'].invoke
end
