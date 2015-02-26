class Kitchen::DashboardController < ApplicationController

  def index
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to dashboard_path
      end
      format.html do
        @product = Product.find_by_internal_name('kitchen')
        @accounts = [@account]

        kitchen_dataset = Job.dataset_with(
          :scalars => {
            :status => ['status'],
            :repository_name => [:data, :github, :repository, :full_name]
          }
        ).where(
          :id => Job.current_dataset_ids,
          :account_id => current_user.run_state.current_account.id
        ).where{
          created_at > 7.days.ago
        }
        @data = Hash[
          @accounts.map do |acct|
            [
              acct,
              Hash[
                @product.repositories_dataset.where(:account_id => acct.id).all.map do |repo|
                  repo_data = kitchen_dataset.where(:repository_name => repo.name).last
                  if repo_data
                    [repo, Smash.new(
                       :completed => repo_data.payload[:data][:kitchen][:result][:complete],
                       :logs => repo_data.payload[:data][:kitchen][:result][:logs]
                     )
                    ]
                  end
                end
              ]
            ]
          end
        ]
      end
    end
  end

end
