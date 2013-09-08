namespace :figaro do
  desc "Configure Heroku according to application.yml"
  task :heroku, [:app, :file] => :environment do |_, args|
    Figaro::Tasks::Heroku.new(args[:app], args[:file]).invoke
  end
end
