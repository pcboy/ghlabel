require "ghlabel/version"

module Ghlabel
  class Ghlabel
    def initialize(token: token, repo: nil, organization: nil)
      @token = token
      @user = github.users.get.login

      if organization.nil? && organizations.count > 1
        warn "You have more than one organization (#{organizations}), please choose one as parameter or we'll use your personal one"
      end
      @organization = organization || @user 
      @repo = repo || current_repo
    end

    def pr_from_ref(ref)
      prs = iterate(github.pull_requests, date: @date, behavior: :from_date) do |iterator|
        iterator.list(user: @organization, repo: @repo, state: 'all')
      end.map{|x| {ref: x.head.ref, title: x.title, created_at: x.created_at, merged_at: x.merged_at, href: x['_links']['self']['href'] }}
      prs.find{|x| x[:ref] == ref.gsub('refs/heads/', '')}
    end

    private

    def current_repo
    end

    def organizations
      @_orgz ||= github.organizations.list.map{|x| x.login}
    end

    def github
      @_github ||= Github.new oauth_token: @token
    end

  end
end
