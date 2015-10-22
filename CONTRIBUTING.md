# Contributing

## Reporting issues

We use GitHub for tracking Fuchsia issues. For a given repo:
https://github.com/fuchsia/REPO/issues

We also inhabit the #fnl channel on irc.freenode.net.

## Contributor setup

### Fuchsia installation

Follow the installation instructions in [README.md] to set up a
`JIRI_ROOT` directory and fetch all Fuchsia repositories.

The instructions below assume you've set the `JIRI_ROOT` environment
variable and have added `$JIRI_ROOT/devtools/bin` to your `PATH`:

    # Edit to taste.
    export JIRI_ROOT=${HOME}/fuchsia
    export PATH=$PATH:$JIRI_ROOT/devtools/bin

Recommended: Add the lines above to your `~/.bashrc` or similar.

### Contributor License Agreement

Gerrit serves as the gatekeeper and uses your e-mail address as the
key. To send your first change to the Fuchsia project from a given
address, you must have completed one of the contributor license
agreements:

- If you are the copyright holder, you will need to agree to the
  [individual contributor license
  agreement](https://developers.google.com/open-source/cla/individual),
  which can be completed online.
- If your organization is the copyright holder, the organization will
  need to agree to the [corporate contributor license
  agreement](https://developers.google.com/open-source/cla/corporate). (If
  the copyright holder for your code has already completed the
  agreement in connection with another Google open source project, it
  does not need to be completed again.)

You can use the links above to create and sign the contributor license
agreement or you can show your current agreements and create new ones
through the [Gerrit][gerrit] interface. Log into Gerrit, click your
name in the upper-right, choose "Settings", then select "Agreements"
from the topics on the left. If you do not have a signed agreement
listed here, you can create one by clicking "New Contributor
Agreement" and following the steps.

This rigmarole only needs to be done for your first submission for
each email address.

### Credentials

To send code reviews and commit changes, you must create an account on
fuchsia.googlesource.com:

1. Go to https://fuchsia.googlesource.com, log in with your identity, click on
   "Generate Password", and follow the instructions to store the credentials for
   accessing fuchsia.googlesource.com locally.
2. Go to https://fuchsia-review.googlesource.com and log in with your identity.
   This will create an account for you in the code review system.

### Proposing a change

Before starting work on a large change, we recommend that you file an
issue with your idea so that other contributors and authors can
provide feedback and guidance. (For small changes, this is not necessary.)

### Making a change

All of the individual Fuchsia projects use [Git] for version
control. Once your code has been reviewed and approved, it will be
merged into the remote via our code review system and brought to your
local instance via `jiri update`.

**The only way to contribute to Fuchsia is via the Gerrit code review process.**

The jiri tool, with its `jiri cl` command, simplifies this process by
managing the interactions between your local git repository and the
remote gerrit instance.

In particular, the `jiri cl mail` step below is essentially wrapping up:

    git push origin HEAD:refs/for/master

which you can do manually to push changes to gerrit.

#### Creating a change

1. Sync the master branch to the latest version of the project.

        jiri update

2. Optionally, create a new branch for your change.

       # Replace `<branch>` with your branch name.
       jiri cl new <branch>

3. Make modifications to the project source code.
4. Stage any changed files for a commit.

        git add <file1> <file2> ... <fileN>

5. Commit your modifications.

        git commit

6. Repeat steps 3-5 as necessary.

#### Syncing a change to the latest version of the project

1. Update all of the local master branches using the `jiri` command.

       jiri update

2. If you are not already on it, switch to the branch that corresponds
   to the change you are trying to bring up to date with the upstream.

       git checkout <branch>
       # If on a feature branch (i.e. not master):
       git merge master

3. If there are no conflicts, you are done.
4. If there are conflicts:

   * Manually resolve the conflicting files.
   * Stage the resolved files for a commit with `git add <pathspec>...`.
   * Commit the resolved files with `git commit`.

#### Requesting a review

1. Switch to the branch that corresponds to the change in question.

        git checkout <branch>

2. Submit your change to Gerrit with the `jiri cl` command.

       # <reviewers> is a comma-seperated list of emails or LDAPs
       # Alternatively reviewers can be added via the Gerrit UI
       jiri cl mail -r=<reviewers>

If you are not sure who to add as a reviewer, you can leave off the
`-r` flag.  You can also let us know about your change by filing an
issue on GitHub or talking to us in our IRC channel.

#### Reviewing a change

1. Follow the link you received in an email notifying you about a
   review request.
2. Add comments as you see fit.
3. When you are finished, click on the "Reply" button to submit your
   comments, selecting the appropriate score. Fuchsia reviewers interpret the
   scores as follows:
  * -2: There's something wrong with the design and this needs a
    rewrite to use a different approach.
  * -1: There's a bug or edge cases in this that absolutely needs to
    be fixed before submitting (mostly useful when there are multiple
    reviewers and you need to negate a previously given positive
    score).
  * 0: The default score. This is typically used when adding comments,
    style nits, or replying.
  * +1: lgtm. But I'm not familiar enough to field issues if the
    author is unreachable. Not sufficient to submit the change.
  * +2: lgtm. I understand this part of the enough to handle
    bugs/issues if the author is unreachable. Necessary from at least
    one reviewer to submit the change.

#### Addressing review comments

1. Switch to the branch that corresponds to the change in question

        git checkout <branch>

2. Modify and commit code as as described [above](#creating-a-change). You can
   either create new commits via `git commit`, or amend the previous commit via
   `git commit --amend`.
3. Be sure to address each review comment on Gerrit.
4. Once you have addressed all review comments be sure to reply at the top of
   the Gerrit UI for the specific patch.
5. Once you have addressed all review comments, you can update the change with a
   new patch using:

        jiri cl mail

#### Submitting a change

1. Work with your reviewers to receive "+2" score. If your change no
   longer applies cleanly due to upstream changes, the reviewer may
   ask you to rebase it manually. Sometimes this can be done via the
   Gerrit web interface, but sometimes you will need to follow the
   steps in the section above: ["Syncing a change to the latest
   version of the
   project"](#syncing-a-change-to-the-latest-version-of-the-project)
   and then run `jiri cl mail` again.
2. The reviewer will submit
   your change and it will be merged into the master branch.
3. Optional: Delete the feature branch once it has been submitted:

       git checkout master
       jiri cl cleanup <branch>

[README.md]: ../README.md
[cla]: https://cla.developers.google.com/about/google-individual?csw=1
[corp-cla]: https://cla.developers.google.com/about/google-corporate?csw=1
[git]: http://git-scm.com/
[gerrit]: https://fuchsia-review.googlesource.com
