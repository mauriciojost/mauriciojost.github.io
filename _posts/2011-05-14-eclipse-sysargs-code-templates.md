---
layout: post
title: Eclipse sysargs code templates
comments: true
tags:
- Code template
- Eclipse
- Java
- Sysargs
---

Eclipse provides many useful shortcuts including code templates such as `sysout`, `syserr`, `systrace` that you can use with autocompletion (CTRL + Space). However, sometimes you may want to debug a method call without using the eclipse debugging machinery. In that case, you may have to print the value of received parameters. The following will explain how to configure a new Eclipse code template named `sysargs` that, once used with auto completion, inserts the piece of code required to print the method parameters where the shortcut was used.

<!--more-->

{% highlight java linenos %}
public void method(String arg1, int arg2, Object arg3) {
  sysargs
}
{% endhighlight %}


Concretely, if your purpose is to debug the method above, what you will have to do is to write `sysargs` as depicted on line 2, then press CTRL+Space and you get *automagically* the piece of code below that is ready to be executed for displaying parameter values.

{% highlight java linenos %}
public void method(String arg1, int arg2, Object arg3) {
  System.out.println(
    "my.package.MyClass#method(arg1, arg2, arg3) = ("
      + Arrays.toString(new Object[] { arg1, arg2, arg3 }) + ")");
}
{% endhighlight %}


The configuration is really simple. Go to *Preferences*, *Java*, *Editor*, *Templates*. Then, click on the *New* button and enter the name *sysargs* for your new code template. Finally, copy/paste the following piece of code as pattern.

{% highlight java %}
System.out.println(
  "${enclosing_package}.${enclosing_type}#${enclosing_method}(${enclosing_method_arguments}) = ("
    + Arrays.toString(new Object[] {${enclosing_method_arguments}}) + ")");
{% endhighlight %}

That's all, you are ready to use sysargs!
