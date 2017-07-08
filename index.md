---
layout: page
title: Hi! My name is Oleksii Oleksenko
permalink: index.html
show_meta: true
# imagefeature path is relative to images/ directory.
imagefeature: av.png
published: true
description: "About me"
category: views
comments: false
mathjax: false
noindex: false
sitemap:
    priority: 0.7
    changefreq: 'monthly'
    lastmod: 2017-07-09
---

<div class="post-author text-center">                       
            <img src="{{ site.urlimg }}{{ site.owner.avatar }}" alt="{{ site.owner.name }}'s photo" itemprop="image" class="post-avatar img-circle img-responsive"/> 
<span class="social-icons" style="padding-top: 10px; padding-bottom: 1px;">
<a href="{{ site.url }}/cv" title="Curriculum Vitae" class="social-icons"><i class="iconm iconm-profile" style="vertical-align: top;"></i></a>
<a href="{{ site.url }}/about/publications/" class="social-icons" title="Publications"><i class="iconm iconm-file-pdf"></i></a>
<a href="{{ site.owner.linkedin }}" class="social-icons" title="LinkedIn profile"><i class="iconm iconm-linkedin2"></i></a>
</span>
</div>


## I am a Computer Science PhD student interested in security and dependability

Since February 2016, I've been working as a tutor and a Ph.D. student in System Engineering group at TU Dresden. Previously, I received my Master Degree in  Distributed Systems Engineering from the TU Dresden in 12/2015. And prior to that, I received a Master Degree in Telecommunications from NTUU "KPI". 

Currently, I'm mainly working with cache side-channel attacks and defense mechanisms against them, especially in the context of Intel SGX.
I also have experience with memory safety ([SGXBounds](http://dl.acm.org/citation.cfm?id=3064192)), Intel MPX ([MPX explained](https://intel-mpx.github.io/)), and different implementations of SIMD technology ([Elzar](http://se.inf.tu-dresden.de/pubs/papers/Kuvaiskii2016elzarTechReport.pdf)).

More information about me on [my university page](https://tu-dresden.de/die_tu_dresden/fakultaeten/fakultaet_informatik/sysa/se/team/people/o_oleksenko) and on [LinkedIn](https://www.linkedin.com/in/oleksiioleksenko).

<br/>
<br/>

# My recent posts:

<br/>

<div class="posts">
  {% for post in site.categories.featured limit:2 %}
  <div class="post">
    <h2 class="post-title">
      <a href="{{ site.url }}{{ post.url }}">
        {{ post.title }}
      </a>
    </h2>

  {% if post.modified.size > 2 %}<span class="post-date indexpg" itemprop="dateModified" content="{{ post.modified | date: "%Y-%m-%d" }}"><i class="fa fa-edit" title="Last updated"> {{ post.modified | date_to_string }}</i> <a href="{{ site.url }}/featured" title="Featured posts"><i class="fa fa-paperclip" title="Featured" class="social-icons"></i></a></span>{% else %}<span class="post-date indexpg" itemprop="datePublished" content="{{ post.date | date: "%Y-%m-%d" }}"><i class="fa fa-calendar" title="Date published"> {{ post.date | date_to_string }}</i> <a href="{{ site.url }}/featured" title="Featured posts"><i class="fa fa-paperclip" title="Featured" class="social-icons"></i></a></span>{% endif %}

 {% if post.description.size > 140 %}{{ post.description | markdownify | remove: '<p>' | remove: '</p>' }}{% else %}{{ post.excerpt | markdownify | remove: '<p>' | remove: '</p>' }}{% endif %} <a href="{{ site.url }}{{ post.url }}" title="Read more"><strong>Read more...</strong></a>
  </div>
  <hr class="transp">
  {% endfor %}
</div>

<div class="posts">
  {% for post in site.posts limit:2 %}
  {% unless post.category contains "featured" %}
  <div class="post">
    <h2 class="post-title">
      <a href="{{ site.url }}{{ post.url }}">
        {{ post.title }}
      </a>
    </h2>

  {% if post.modified.size > 2 %}<span class="post-date indexpg" itemprop="dateModified" content="{{ post.modified | date: "%Y-%m-%d" }}"><i class="fa fa-edit" title="Last updated"> {{ post.modified | date_to_string }}</i></span>{% else %}<span class="post-date indexpg" itemprop="datePublished" content="{{ post.date | date: "%Y-%m-%d" }}"><i class="fa fa-calendar" title="Date published"> {{ post.date | date_to_string }}</i></span>{% endif %}

 {% if post.description.size > 140 %}{{ post.description | markdownify | remove: '<p>' | remove: '</p>' }}{% else %}{{ post.excerpt | markdownify | remove: '<p>' | remove: '</p>' }}{% endif %} <a href="{{ site.url }}{{ post.url }}" title="Read more"><strong>Read more...</strong></a>
  </div>
  {% unless forloop.last %}<hr class="transp">{% endunless %}
  {% endunless %}
  {% endfor %}
</div>
<h3 class="post-title">
<div class="pagination" style="margin: 0.5rem;">
    <a class="pagination-item older" href="{{ site.url }}/blog"><i class="fa fa-edit"> Blog</i></a>
    <a class="pagination-item newer" href="{{ site.url }}/tags"><i class="fa fa-tags"> Tags</i></a>
</div>
</h3>
