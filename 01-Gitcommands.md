```
Where the code leave?
Local directory, stage, local repository and remote repository
How to download remote repositoty?
use git clone url
How to create empty repository
git init => it creates a .git file and main branch
What needs to be added after creating the empty repo?
add user.name, user.email and remote.origin.url
git config --global or --system or --local user.name=chakra
git config --global or --system or --local user.email=chakra@gmail.com
How to get the list the config?
git config --list
How to edit config
git config --edit
What is the purpose of config?
The config or identity is used at every commit.
How to commit changes to local repo?
git commit -m "message"
how to add files to stage?
git add filename
how to see what is in stage/tracked and untracked?
git status
how to remove the files from stage?
git reset --mixed or --soft
how to remove the modified files from untracked history?
git reset --hard
git reset HEAD sample
how to check the commit history?
git log
How to integregate featchure branch to main branch in local repo
from main branch issue git merge branch_name
how to upload contents from local repo to remote repo?
git push -a origin main
How to create, list and delete branch
git branch (for listing)
git branch <name> (for creating)
git branch -D <name> (for deleting B not fully merged in local repo)
git branch -d <name> (fully merged)
git puch --delete chakra
What is git rebase?
Merge base of freature branch to main branch
what is git merge?
Merge latest feature brach with main branch, loose data
what is git squash and merge
All changes in feature branch merged with main branch, all versions.
```

