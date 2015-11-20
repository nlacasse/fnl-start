# Backporting Changes

To backport a series of commits that apply *without conflicts*, follow these steps:

Create a local branch and cherry-pick the commits you want to it. Make sure the branch you're cherry-picking from is publicly visible.

```
git branch squid-backports
git cherry-pick -x <commit>...
```

Push the branch to a remote branch.

```
git push origin squid-backports:refs/heads/squid-backports
```

Merge the remote branch with `master` and add a note on where the commit came from.

```
git checkout -b master origin/master
git merge --no-ff remotes/origin/squid-backports // always create a merge commit
```

In the commit message:

```
Merge remote-tracking branch 'remotes/origin/squid-backport' into master

  Pull in patches from mainline for delicious seafood

  - <commit msg from cherry-picked commit>
  - <another commit msg>
```

Amend the commit to create a Change-Id (from commit hook)

```
git commit --amend
```

Push the current branch for review

```
git push origin HEAD:refs/for/master
```
