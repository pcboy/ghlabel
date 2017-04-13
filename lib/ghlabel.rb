require "ghlabel/version"
require 'github_api'
require 'active_support/core_ext/object/try'
require 'looksee'

require 'awesome_print'

module Ghlabel
  class Ghlabel
    def initialize(token:, repo: nil, organization: nil, with_references: true)
      @token = token
      @user = github.users.get.login

      if organization.nil? && organizations.count > 1
        warn "You have more than one organization (#{organizations}), please choose one as parameter or we'll use your personal one"
      end
      @organization = organization || @user 
      @repo = repo || current_repo
      @with_references = with_references

      @pr = pr_from_ref(File.read('.git/HEAD').gsub('ref: ', '').strip)
    end

    def remove_labels(labels)
      related_issues = if @with_references
        @pr[:title].scan(/\#(\d+)/).flatten
      end || []
      ([@pr[:issue_number]] + related_issues).map do |issue_number|
        github.issues.edit(user: @organization, repo: @repo, number: issue_number, labels: current_labels(issue_number) - labels)
      end
    end

    def add_labels(labels)
      related_issues = if @with_references
        @pr[:title].scan(/\#(\d+)/).flatten
      end || []
      ([@pr[:issue_number]] + related_issues).map do |issue_number|
        github.issues.edit(user: @organization, repo: @repo, number: issue_number, labels: current_labels(issue_number) + labels)
      end
    end

    private
    def pr_from_ref(ref)
      prs = github.pull_requests.list(user: @organization, repo: @repo, state: 'open', auto_pagination: true)
        .map{|x| {id: x.id, ref: x.head.ref, title: x.title, created_at: x.created_at, merged_at: x.merged_at,
                  href: x['_links']['self']['href'], issue_number: /\/(\d+)$/.match(x['_links']['issue']['href']).captures.first }}
      prs.find{|x| x[:ref] == ref.gsub('refs/heads/', '')}
    end

    def current_labels(issue_number)
      pr_issue = github.issues.get(user: @organization, repo: @repo, number: issue_number)
      pr_issue.labels.map(&:name)
    end

    def current_repo
      @_repo_info ||= (/url = git@github.com:.*\/(.*).git/.match(File.read('.git/config')).captures.try(:first))
    end

    def organizations
      @_orgz ||= github.organizations.list.map{|x| x.login}
    end

    def github
      @_github ||= Github.new oauth_token: @token
    end

  end
end
