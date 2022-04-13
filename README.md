# Erikw's Homebrew Tap
My own [Homebrew](https://brew.sh/) tap featuring formulas for:
* [ozangulle/xdg-urlview](https://github.com/ozangulle/xdg-urlview)
* [erikw/restic-automatic-backup-scheduler](https://github.com/erikw/restic-automatic-backup-scheduler)

## How do I install these formulae?
As one command `brew install erikw/tap/<formula>`, or `brew tap erikw/tap` followed by `brew install <formula>`.

Here are all formulas provided by this tap:
```console
$ brew install erikw/tap/xdg-urlview
$ brew install erikw/tap/restic-automatic-backup-scheduler
```

## Documentation
`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

* https://docs.brew.sh/Formula-Cookbook
* How to upload bottles - https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/


## Development
* Clone this git repo with the ssh protocol instead of https, by tapping. You should really clone the repo with brew-tap, as otherwise commands like brew-audit won't work.
   ```console
   $ brew tap erikw/tap git@github.com:erikw/homebrew-tap.git
   ```
  * At a later point, return here with:
     ```console
     cd "$(brew --repository erikw/homebrew-tap)"
     ```
* To create a new Formula:
   ```console
   $ brew --tap erikw/homebrew-tap <url-to-source-files.tar.gz>
   ```
* Build from source:
  ```console
  $ brew install --verbose --debug --build-from-source restic-automatic-backup-scheduler
  $ brew reinstall --build-from-source restic-automatic-backup-scheduler
  ```
* Test a formula for erros:
  ```console
  $ brew audit --new-formula restic-automatic-backup-scheduler
  $ brew audit --strict --online restic-automatic-backup-scheduler
  ```
* Run tests only:
   ```console
   $ brew test restic-automatic-backup-scheduler
   ```
* Update a version & build new bottles [bottles](https://docs.brew.sh/Bottles):
  1. Create a PR in the GitHub repo
     * Only one file changed per PR: `Autosquash can't split commits that modify multiple files.`
     * For easy version upgrades:
     ```console
     $ brew bump-formula-pr --version 7.3.0 restic-automatic-backup-scheduler
     $ brew bump-formula-pr --version 7.3.0 restic-automatic-backup-scheduler-check
     ```
  1. Wait for the PR builds [test.yml](.github/workflows/tests.yml) to become green
  1. Apply the PR label `pr-pull`. This will trigger the second flow from [publish.yml](.github/workflows/publish.yml) will run and create the bottle.
