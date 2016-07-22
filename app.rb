require 'sinatra/base'
require 'sinatra/sequel'

module WorkForwardNola
  # WFN app
  class App < Sinatra::Base
    register Sinatra::SequelExtension
    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
        "postgres://localhost:5432/workforwardnola"
        # TODO: put this url in env file
      }
    end

    # TODO figure out how to only run in dev mode, not tasks
    # check for un-run migrations
    # Sequel.extension :migration
    # Sequel::Migrator.check_current(database, 'db/migrations')

    register Mustache::Sinatra
    require './views/layout'

    dir = File.dirname(File.expand_path(__FILE__))

    set :mustache,
        namespace: WorkForwardNola,
        templates: "#{dir}/templates",
        views: "#{dir}/views"

    before do
      response.headers['Cache-Control'] = 'public, max-age=36000'
    end

    get '/' do
      @title = 'Work Forward NOLA'
      mustache :index
    end

    # yes, this is lazy and not really correct but waiting until we have
    # more specific requirements
    get %r{^(?!\/favicon.ico$)} do
      @title = 'Assessment'
      mustache request.path_info.delete('/').to_sym
    end
  end
end
