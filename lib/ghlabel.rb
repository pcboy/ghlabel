require "ghlabel/version"
require 'github_api'
require 'active_support/core_ext/object/try'

module Ghlabel
  class Ghlabel
    def initialize(token:, repo: nil, organization: nil, with_references: true, pr_number: nil)
      @token = token
      @user = github.users.get.login

      @organization = organization || current_repo_info[:organization] 
      @repo = repo || current_repo_info[:repo]
      @with_references = with_references

      @pr = pr_number ? pr_from_num(pr_number) : pr_from_ref(File.read('.git/HEAD').gsub('ref: ', '').strip)
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

    def pr_from_num(pr_number)
      pr = github.pull_requests.get(user: @organization, repo: @repo, number: pr_number)
      {id: pr.id, ref: pr.head.ref, title: pr.title, created_at: pr.created_at, merged_at: pr.merged_at,
       href: pr['_links']['self']['href'], issue_number: /\/(\d+)$/.match(pr['_links']['issue']['href']).captures.first}
    end

    def pr_from_ref(ref)
      prs = github.pull_requests.list(user: @organization, repo: @repo, state: 'all', auto_pagination: true)
        .map{|x| {id: x.id, ref: x.head.ref, title: x.title, created_at: x.created_at, merged_at: x.merged_at,
                  href: x['_links']['self']['href'], issue_number: /\/(\d+)$/.match(x['_links']['issue']['href']).captures.first }}
      prs.find{|x| x[:ref] == ref.gsub('refs/heads/', '')}
    end

    def current_labels(issue_number)
      pr_issue = github.issues.get(user: @organization, repo: @repo, number: issue_number)
      pr_issue.labels.map(&:name)
    end

    def current_repo_info
      organization, repo = (/url = git@github.com:(.*)\/(.*).git/.match(File.read('.git/config')).captures)
      {organization: organization, repo: repo}
    end

    def organizations
      @_orgz ||= github.organizations.list.map{|x| x.login}
    end

    def github
      @_github ||= Github.new oauth_token: @token
    end

  end
end
