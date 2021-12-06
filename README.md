# Xdg-urlview Homebrew Tap
A tap for installing [ozangulle/xdg-urlview](https://github.com/ozangulle/xdg-urlview)

## How do I install these formulae?
`brew install erikw/xdg-urlview/<formula>`

Or `brew tap erikw/xdg-urlview` and then `brew install <formula>`.

More speciically you probably want

`brew install erikw/xdg-urlview/xdg-urlview`

## Documentation
`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

* How to upload bottles - https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/


## Development
Clone this git repo with the ssh protocol instead of https, by tapping like this:
```console
$ brew tap erikw/xdg-urlview git@github.com:erikw/homebrew-xdg-urlview.git
```

You should really clone the repo with brew-tap, as otherwise commands like brew-audit won't work.

Test a formula for erros now like

```console
$ brew audit --new-formula xdg-urlview
```
