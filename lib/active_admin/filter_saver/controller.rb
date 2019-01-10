module ActiveAdmin
  module FilterSaver

    # Extends the ActiveAdmin controller to persist resource index filters between requests.
    #
    # @author David Daniell / тιηуηυмвєяѕ <info@tinynumbers.com>
    module Controller

      private

      SAVED_FILTER_KEY = :last_search_filter

      def restore_search_filters
        # puts '123'
        filter_storage = session[SAVED_FILTER_KEY]
        # puts filter_storage
        # puts '222222'
        # puts params
        # puts '333333'
        if params[:clear_filters].present?
          params.delete :clear_filters
          if filter_storage
            logger.info "clearing filter storage for #{controller_key}"
            filter_storage.delete controller_key
          end
          if request.post?
            # we were requested via an ajax post from our custom JS
            # this render will abort the request, which is ok, since a GET request will immediately follow
            render json: { filters_cleared: true }
          end
        elsif filter_storage && params[:action].to_sym == :index && params[:q].blank?
          # puts '0000'
          # puts filter_storage
          # puts controller_key
          saved_filters = filter_storage[controller_key]
          # puts saved_filters
          # puts '11111'
          unless saved_filters.blank?
            # puts '11111333333--------'
            params[:q] = saved_filters
          end
        end
      end

      def save_search_filters
        # puts '234'
        # puts controller_key
        if params[:action].to_sym == :index
          session[SAVED_FILTER_KEY] ||= Hash.new
          session[SAVED_FILTER_KEY][controller_key] = params[:q]
          # puts params[:q]
        end
      end

      # Get a symbol for keying the current controller in the saved-filter session storage.
      def controller_key
        #params[:controller].gsub(/\//, '_').to_sym
        current_path = request.env['PATH_INFO']
        current_route = Rails.application.routes.recognize_path(current_path)
        current_route.sort.flatten.join('-').gsub(/\//, '_')#.to_sym
      end

    end

  end
end