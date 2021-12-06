# xdg-urlview Homebrew Tap
A tap for installing [ozangulle/xdg-urlview](https://github.com/ozangulle/xdg-urlview).

## How do I install these formulae?
`brew install erikw/xdg-urlview/<formula>`

Or `brew tap erikw/xdg-urlview` and then `brew install <formula>`.

More speciically you probably want

`brew install erikw/xdg-urlview/xdg-urlview`

## Documentation
`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

* https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md
* How to upload bottles - https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/


## Development
Clone this git repo with the ssh protocol instead of https, by tapping like this:
```console
$ brew tap erikw/xdg-urlview git@github.com:erikw/homebrew-xdg-urlview.git
```
You should really clone the repo with brew-tap, as otherwise commands like brew-audit won't work.

At a later point, return here by:
```console
cd "$(brew --repository erikw/homebrew-xdg-urlview)"
```



Test a formula for erros now like:
```console
$ brew audit --new-formula xdg-urlview
$ brew audit --strict --online xdg-urlview
```

Run tests only like:
```console
$ brew test xdg-urlview
```


Build from source like:
```console
$ brew install --build-from-source xdg-urlview
$ brew reinstall --build-from-source xdg-urlview
```


New versions of xdg-urlview can be updated with
```console
$ brew bump-formular-pr xdg-urlview ...
```

To build a new [bottle](https://docs.brew.sh/Bottles)

1. create a PR in the GitHub repo
1. wait for the PR checks to become green
1. apply the label `pr-pull`. This will trigger the second flow from .github/workflows/publish.yml will run and create the bottle.
