# prefix-css

A tool for prefixing all rules from css-files with some selector.

[DEMO](https://vic.github.com/prefix-css)

### Installation

`npm install -g prefix-css`

### Why?

Well, sometimes you find that you'd like all rules from a css-file to apply but only while scoped under a specific selector.

ie, we all love using [Twitter Bootstrap](http://twitter.github.com/bootstrap/), imagine you could easily combine themes from [BootSwatch](http://bootswatch.com/) on a single page by having each theme prefixed by a css selector.  

## Use case

suppose, for example that you're happily using the [cyborg theme](http://bootswatch.com/cyborg/), but for some particular portion you want to apply the colors from the [slate theme](http://bootswatch.com/slate/). 

if you downloaded both themes as `cyborg.min.css` and `slate.min.css`, you could use `prefix-css` to 
 namespace each theme under a css-selector:

```shell
$ prefix-css .cyborg cyborg.min.css > cyborg.prefixed.min.css
$ prefix-css .slate  slate.min.css  > slate.prefixed.min.css
```

```html
<div class='cyborg'>
  <a href='#' class="btn btn-primary">A Cyborg Button</a>
</div>

<div class='slate'>
  <a href='#' class="btn btn-primary">An Slate Button</a>
</div>
```

[see it in action](https://vic.github.com/prefix-css)

