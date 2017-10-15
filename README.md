# mauriciojost.github.io

## Installation

To install execute:

```bash
# Install ruby
# sudo apt-get install ruby2.4

# Install jekyll for blog generation from static files
gem install jekyll

# Install redcarpet markdown interpreter
gem install redcarpet

# Ensure all submodules to this project are properly cloned too
git submodule update --init --recursive
```


## Jekyll usage

Preview is available during development if content was served by Jekyll:

```bash
jekyll serve
```

Default output folder is `_site/`.

## Deployment on Github

Use subtree push to send it to the frontend branch on GitHub:

```bash
git checkout development
jekyll serve
git commit -a -s -m "Publish site"
git push
git subtree push --prefix _site origin master
```

## Acknowledgment

Thanks to [Laurent Pellegrino](http://www.pellegrino.link/) for the blog template!
