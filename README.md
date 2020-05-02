# mauriciojost.github.io

[![github.io](https://img.shields.io/badge/github-io-22bb22.svg)](https://mauriciojost.github.io/)

Simply my technical notes made posts. 

## Installation

To install execute:

```bash
# Install ruby 2.4 or 2.5
sudo apt-get install ruby2.4
sudo apt-get install ruby2.5

# Install jekyll for blog generation from static files
sudo gem install jekyll -v 4.0

# Ensure all submodules to this project are properly cloned too
git submodule update --init --recursive
```


## Jekyll usage

Preview is available during development if content was served by Jekyll:

```bash
jekyll serve
jekyll serve --drafts
```

Default output folder is `_site/`.

### Write a new post

New posts are added in `_posts` directory, respecting the file naming convention.

Layouts define the form of a post:

- `post`: will use `Jekyll` itself
- `presentation`: will use `reveal.js`

See existing example post for more information. 

## Deployment on Github

```bash
bash publish.sh
```

## Acknowledgment

Thanks to [Laurent Pellegrino](http://www.pellegrino.link/) for the blog template!
