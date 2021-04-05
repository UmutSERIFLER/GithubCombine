//
//  UserReposDetailModel.swift
//  GithubAPICombine
//
//  Created by Umut SERIFLER on 27/03/2021.
//  Copyright © 2021 Umut SERIFLER. All rights reserved.
//

import Foundation

// MARK: - UserReposDetailModel
struct UserReposDetailModel: Decodable {
    let id: Int
    let node_id, name, full_name: String
    //let ´private´: Bool
    let owner: RepoOwner
    let html_url: String
    let description: String?
    let fork: Bool
    let url, forks_url: String
    let keys_url, collaborators_url: String
    let teams_url, hooks_url: String
    let issue_events_url: String
    let events_url: String
    let assignees_url, branches_url: String
    let tags_url: String
    let blobs_url, git_tags_url, git_refs_url, trees_url: String
    let statuses_url: String
    let languages_url, stargazers_url, contributors_url, subscribers_url: String
    let subscription_url: String
    let commits_url, git_commits_url, comments_url, issue_comment_url: String
    let contents_url, compare_url: String
    let merges_url: String
    let archive_url: String
    let downloads_url: String
    let issues_url, pulls_url, milestones_url, notifications_url: String
    let labels_url, releases_url: String
    let deployments_url: String
    let created_at, updated_at, pushed_at: String
    let git_url, ssh_url: String
    let clone_url: String
    let svn_url: String
    let homepage: String?
    let size, stargazers_count, watchers_count: Int
    let language: String?
    let has_issues, has_projects, has_downloads, has_wiki: Bool
    let has_pages: Bool
    let forks_count: Int
    let archived, disabled: Bool
    let open_issues_count: Int
    let forks, open_issues, watchers: Int
    let default_branch: String

}

// MARK: - RepoOwner
struct RepoOwner: Decodable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url, html_url, followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url, organizations_url, repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
}
