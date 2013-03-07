require "bundler/gem_tasks"
Bundler.require

namespace :db do
  desc "Run migrations"
  task :migrate => [:setup] do
    Sequel::Migrator.run(@database, "db/migrations")
  end

  desc "Reset database"
  task :reset => [:setup] do
    Sequel::Migrator.run(@database, "db/migrations", :target => 0)
    Sequel::Migrator.run(@database, "db/migrations")
  end

  task :setup do
    Sequel.extension :migration

    if ENV["TRAFFIC_SPY_ENV"] == "test"
      database_file = 'db/traffic_spy-test.sqlite3'
      @database = Sequel.sqlite database_file
    else
      @database = Sequel.postgres "traffic_spy"
    end

  end
end

desc "Create payloads."
task :payloads do
  10.times do
    articles = %w(blog article news jorge)
    a = articles.sample
    sources = %w(jumpstartlab facebook google jorge blair tacobell friendster)
    b = sources.sample
    events = %w(SociaLogin HappyDay SadDay DubiousDay TacoDay 5deMayoDay)
    c = events.sample

    `curl -i -d 'payload={"url":"http://#{b}.com/#{a}","requestedAt":"#{Time.now}","respondedIn":#{(1..100).to_a.sample},"referredBy":"http://#{sources.sample}.com","requestType":"GET","parameters":[],"eventName": "#{c}","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"#{(600..1200).to_a.sample}","resolutionHeight":"#{(600..1200).to_a.sample}","ip":"#{(1..255).to_a.sample}.#{(1..255).to_a.sample}.#{(1..255).to_a.sample}.211"}' http://localhost:9393/sources/#{b}/data`
    sleep 0.2
  end
end

namespace :sanitation do
  desc "Check line lengths & whitespace with Cane"
  task :lines do
    puts ""
    puts "== using cane to check line length =="
    system("cane --no-abc --style-glob 'lib/**/*.rb' --no-doc")
    puts "== done checking line length =="
    puts ""
  end

  desc "Check method length with Reek"
  task :methods do
    puts ""
    puts "== using reek to check method length =="
    system("reek -n lib/**/*.rb 2>&1 | grep -v ' 0 warnings'")
    puts "== done checking method length =="
    puts ""
  end

  desc "Check both line length and method length"
  task :all => [:lines, :methods]
end

# THIS SPACE RESERVED FOR EVALUATIONS
#
#
#
#
# THIS SPACE RESERVED FOR EVALUATIONS
