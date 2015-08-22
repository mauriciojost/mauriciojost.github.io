---
layout: post
title: Brace expansion with Unix Shells
comments: true
tags:
- Brace expansion
- Bash
- Csh
- Ksh
- Shell
---

Recently, I discovered a great feature that most of recent [Shells](https://en.wikipedia.org/wiki/Unix_shell) support. It is named _brace expansion_. I used it occasionally but without knowing how it behaves and what was its power.

Below is an example:

{% highlight bash %}
$ echo I{like,love,hate}chocolate
Ilikechocolate Ilovechocolate Ihatechocolate
{% endhighlight %}

<!--more-->

In this example, `{like,love,hate}` has a special meaning: it's a list of String elements delimited by braces whose elements are expanded with the word it is attached with. As the output shows, once evaluated each String element creates a new word by replacing the list by its value.

Ok, that's interesting but could it be used with a concrete example? the answer is yes. Let's say that you need to create several folders in a same directory. The simplest manner I was aware of was to move to the desired folder and then to use the `mkdir` command for each directory:

{% highlight bash %}
$ cd ~
$ mkdir -p Images
$ mkdir -p Movies
$ mkdir -p Music
{% endhighlight %}

The previous sequence of commands can be written pretty quickly but requires fingers gymnastic using keyboard shortcuts. With brace expansion, the previous example can be easily one-lined:

{% highlight bash %}
$ mkdir -p ~/{Images,Movies,Music}
{% endhighlight %}

# Nested brace expansion

Brace lists can be composed. For instance, the example above can be extended to create a hierarchy of folders quickly:

{% highlight bash %}
$ mkdir -p ~/{Images/{Cars,Family,House,Vacations},Movies,Music}
{% endhighlight %}

It will create the following folders in your home directory:

{% highlight text %}
Images/Cars
Images/Family
Images/House
Images/Vacations
Movies
Music
{% endhighlight %}

# Generating sequences

If you come from the imperative world (e.g. if you know for instance C or even used loops with Java), you are probably familiar with the 3 parameters loop control expression. You also know how boring it is to write, especially in Shell:

{% highlight bash %}
$ for ((i=1; i<=3; i++)); do echo $i; done
1
2
3
{% endhighlight %}

Using brace sequences, the writing is shorter and more readable:

{% highlight bash %}
$ for i in {1..3}; do echo $i; done
{% endhighlight %}

The general syntax for a sequence expression is `{START..END..INCREMENT}` where _START_ and _END_ is a required integer or single character but _INCREMENT_ an optional integer value (default to 1). Such an expression generates a sequence of integers or characters by _INCREMENT_ step, starting from _START_ to _END_ included. This way, listing odd numbers between _9_ and _17_ is as simple as writing:

{% highlight bash %}
$ echo {9..17..2}
9 11 13 15 17
{% endhighlight %}

While enumerating the alphabet is not more complex:

{% highlight bash %}
$ echo {a..z}
a b c d e f g h i j k l m n o p q r s t u v w x y z
{% endhighlight %}

# Limitations

1. A valid brace expansion must contain at least a comma or a sequence expression.
2. Variable expansion works inside a brace list but not inside a sequence expression.

In conclusion, brace expansion is a really powerful feature that can save you time when you have to create directories, apply permissions, etc. Besides, the good news is that it is supported by almost all recent Shells.
