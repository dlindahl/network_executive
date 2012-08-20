module NetworkExecutive
  class Network < Goliath::API

    use Rack::Static,
      index: 'index.html',
      urls:  [ '/index.html', '/stylesheets' ],
      root:  File.join( NetworkExecutive.root, 'public' )

    def response(env)
      case env['PATH_INFO']
      when '/tune_in'
        Viewer.new.response env
      else
        raise Goliath::Validation::NotFoundError
      end
    end

  end
end