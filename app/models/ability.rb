class Ability
  include CanCan::Ability

  def initialize(current_user)
    current_user ||= User.new # guest user (not logged in)

    alias_action :update, :update_collection, :destroy, :to => :more_than_see
    can :manage, :all

    if not current_user.admin?
      cannot :more_than_see, [Candidate, Employer] do |user|
        user.user.uid != current_user.uid
      end

      # User can modify only their job posts
      cannot :more_than_see, [JobPost] do |post|
        post.employer.user.uid != current_user.uid
      end

      cannot :more_than_see, [Application] do |app|
        puts app
        @@jobPost = JobPost.find_by_uid app.job_post_id
        puts current_user
        puts 'hola'
        current_user.meta_id != @@jobPost.employer_id
      end
    end
  end
end