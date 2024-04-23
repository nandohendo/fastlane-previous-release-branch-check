desc "Previous release branch merging check"
lane :previous_release_branch_check do
    # Check if previous release branch has been merged to current release branch

    # Get Skywalker version number
    version_number = get_version_number(xcodeproj: "YourProject.xcodeproj", target: "YourProjectTarget")
    version_parts = version_number.split(".")
    major_version = version_parts[0]
    minor_version = version_parts[1]
    patch_version = version_parts[2]
    # Get previous minor version
    last_minor_version = (minor_version.to_i - 1).to_s
    current_branch = git_branch
    
    # Loop through previous patch version (anticipate if there are multiple patches because of hotfix)
    for patch_version in 0..100
      complete_last_version = "#{major_version}.#{last_minor_version}.#{patch_version}"

      # Check if previous version branch actually exists
      branch_exists = sh("git ls-remote --heads origin #{complete_last_version} | wc -l").to_i > 0
      if branch_exists
        UI.message("Branch #{complete_last_version} exists")

        # Get commit hash of previous version branch
        commit_hash = sh("git rev-parse origin/release/#{complete_last_version}")

        # Get all branches that contains that commit hash
        branches_containing_commit = sh("git branch --contains #{commit_hash}")
        if branches_containing_commit.include?(current_branch)
          UI.message("Release #{complete_last_version} with commit #{commit_hash} is included in the current branch")
        else
          # abort build
          UI.user_error!("please merge back #{complete_last_version} to #{version_number}")
        end
      else
        UI.message("Branch #{complete_last_version} does not exist, continuing build")
        break
      end
    end
  end