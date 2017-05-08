# mauriciojost.github.io

## Installation

Compiling Jekyll template requires the following packages:

```sh
sudo dnf install ruby-devel.x86_64
gem install jekyll redcarpet
```

## Jekyll usage

Preview is available during development if content was served by Jekyll:

```sh
jekyll serve
```

Default output folder is `_site/`.

## Deployment on Github

Use subtree push to send it to the frontend branch on GitHub:

```sh
git checkout development
jekyll serve
git commit -s -m "Publish site"
git subtree push --prefix _site origin master
```

## Acknowledgment

Thanks to [Laurent Pellegrino](http://www.pellegrino.link/) for the blog template!
