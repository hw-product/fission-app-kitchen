require 'fission-app-kitchen'

module FissionApp
  module Kitchen
    class Engine < ::Rails::Engine

      config.to_prepare do |config|
        product = Fission::Data::Models::Product.find_by_internal_name('kitchen')
        unless(product)
          product = Fission::Data::Models::Product.create(
            :name => 'Kitchen',
            :vanity_dns => 'kitchen.hw-ops.com'
          )
        end
        feature = Fission::Data::Models::ProductFeature.find_by_name('kitchen_full_access')
        unless(feature)
          feature = Fission::Data::Models::ProductFeature.create(
            :name => 'kitchen_full_access',
            :product_id => product.id
          )
        end
        unless(feature.permissions_dataset.where(:name => 'kitchen_full_access').count > 0)
          args = {:name => 'kitchen_full_access', :pattern => '/kitchen.*'}
          permission = Fission::Data::Models::Permission.where(args).first
          unless(permission)
            permission = Fission::Data::Models::Permission.create(args)
          end
          unless(feature.permissions.include?(permission))
            feature.add_permission(permission)
          end
        end
      end

      # @return [Array<Fission::Data::Models::Product>]
      def fission_product
        [Fission::Data::Models::Product.find_by_internal_name('kitchen')]
      end

      # @return [Hash] navigation
      def fission_navigation(product, user)
        {
          'Kitchen' => {
            'Dashboard' => Rails.application.routes.url_helpers.kitchen_dashboard_path,
            'Repositories' => Rails.application.routes.url_helpers.kitchen_repositories_path,
            'Jobs' => Rails.application.routes.url_helpers.kitchen_jobs_path
          }.with_indifferent_access
        }.with_indifferent_access
      end

      # @return [Hash] dashboard information
      def fission_dashboard(*_)
        {
          :kitchen_dashboard => {
            :title => 'Kitchen',
            :url => Rails.application.routes.url_for(
              :controller => 'kitchen/dashboard',
              :action => :index,
              :only_path => true
            )
          }
        }
      end

    end
  end
end
