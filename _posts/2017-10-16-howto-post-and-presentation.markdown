---
layout: [post, presentation]
title: "Writing a post or a presentation? Both!"
date:   2017-10-16 00:00:00 +0200
reveal:
  theme: white
  transition: slide
  controls: true
  progress: true
  history: false
  center: true
tags:
- reveal
- blog
- markdown
---

# Post or slides?

Presentations are great. Blogs too. Which one should do I dedicate my time to?

<!--slide-next-->

No need to choose, you can do **both at once**!

<!--slide-next-->

In this special **post/presentation**, I will give you an example with sources
on how to build your own blog posts, and generate both:

- a post, and
- a presentation

from a single `markdown` file.

<!--more-->

<!--slide-next-->

# First slide

This is an example of an horizontal slide.

Text written here appears in both the presentation and the post layouts.

Press `ESC` to navigate over all the slides.

<!--slide-ignore-begin-->

You can have text that will be ignored in the presentation, but written in the
post, so you can go more into details where it really matters.

<!--slide-ignore-end-->

<!--slide-next-->

# Second slide

<!--slide-down-->

## Second slide (A)

You can add a vertical slide (I personally use them for continuation of the upper slide).

<!--slide-down-->

## Second slide B

Yet another one.

<!--slide-down-->

## Second slide C

Last one including a figure from `Gravizo`:

<span style="display:block;text-align:center">![Alt text](https://g.gravizo.com/svg?
@startuml;
skinparam monochrome false;
caption Figure 1. Example of a figure using Gravizo;
scale max 900 width;
rectangle MARKDOWN;
rectangle BLOG {;
  rectangle POST;
  rectangle PRESENTATION;
};
MARKDOWN --> POST;
MARKDOWN --> PRESENTATION;
note left of MARKDOWN: example;
@enduml;
)

<!--slide-next-->

# References

Here you can find:

- [The generated presentation / slides](https://mauriciojost.github.io/2017/10/16/howto-post-and-presentation/presentation.html)
- [The generated blog post](https://mauriciojost.github.io/2017/10/16/howto-post-and-presentation/post.html)
- [The source markgown file](https://raw.githubusercontent.com/mauriciojost/mauriciojost.github.io/development/_posts/2017-10-10-covariant-contravariant-invariant-in-scala.markdown)
- [Jekyll official page](https://jekyllrb.com/)
- [Reveal.js official git repository](https://github.com/hakimel/reveal.js/)

<!--slide-next-->

# Enjoy!

And [star the project here](https://github.com/mauriciojost/mauriciojost.github.io) if you liked it!