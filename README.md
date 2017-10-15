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

```bash
bash publish.sh
```

## Acknowledgment

Thanks to [Laurent Pellegrino](http://www.pellegrino.link/) for the blog template!
