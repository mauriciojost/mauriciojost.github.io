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
