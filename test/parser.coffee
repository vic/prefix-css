describe 'Parser', ->

  parser = require '../parser'

  describe '#parse body', ->

    body = (content)-> parser.parse content, "body"

    it 'shoud parse simple body', ->
     body("{hello}").should.have.property 'body'

    it 'shoud parse body with nested braces', ->
     body("{he{ll}o}").should.have.property 'body'

    it 'shoud parse body with strings and commas', ->
     body("{he 'll', \"o{o}\" o}").should.have.property 'body'

    it 'shoud return the exact same body', ->
     code = "{he 'll', \"o{o}\" o}"
     body(code).body.should.equal code

  describe '#parse selector', ->
    selector = (content)-> parser.parse content, "selector"

    it 'should parse a css class', ->
      selector(".foo").should.have.property 'selector'
      selector(".foo").selector.should.equal '.foo'
      
    it 'should parse a css id', ->
      selector("#foo").should.have.property 'selector'
      selector("#foo").selector.should.equal '#foo'

    it 'should parse a nested selector', ->
      selector("#foo .bar").should.have.property 'selector'
      selector("#foo .bar").selector.should.equal '#foo .bar'

    it 'should parse a selector with attr', ->
      code = "#foo .bar [foo='22']"
      selector(code).should.have.property 'selector'
      selector(code).selector.should.equal code

    it 'should not parse an @font', ->
      code = "@font"
      (-> selector(code)).should.throw /but "@" found/

  describe '#parse selectors', ->
    selectors = (content)-> parser.parse content, "selectors"

    it 'should parse a single selector', ->
      code = ".foo"
      selectors(code).should.have.property 'selectors'

    it 'should parse two selector', ->
      code = ".foo , bar"
      selectors(code).should.have.property 'selectors'
      selectors(code).selectors[0].should.equal ".foo "
      selectors(code).selectors[1].should.equal " bar"

  describe '#parse rule', ->
    rule = (content)-> parser.parse content, "rule"

    it 'should parse a rule with single selector', ->
      code = "foo{bar}"
      me = rule(code)
      me.should.have.property 'selectors'
      me.should.have.property 'body'
      me.selectors.length.should.equal 1
      me.selectors[0].should.equal "foo"
      me.body.should.equal "{bar}"


    it 'should parse a rule with two selectors', ->
      code = "#foo,.baz{bar}"
      me = rule(code)
      me.should.have.property 'selectors'
      me.should.have.property 'body'
      me.selectors.length.should.equal 2
      me.selectors[0].should.equal "#foo"
      me.selectors[1].should.equal ".baz"
      me.body.should.equal "{bar}"

  describe '#parse media queries', ->
    media = (content)-> parser.parse content, "media"

    it 'should parse rules inside media', ->
      code = "@media(a b c){div{x}}"
      me = media code
      me.rules.length.should.equal 1
      me.rules[0].selectors[0].should.equal "div"
      me.rules[0].body.should.equal "{x}"
      me.media.should.equal "@media(a b c)"

    it 'should parse example query', ->
      code = '@media (max-width:768px){div.subnav .nav>li+li>a,div.subnav .nav>li:first-child>a{border-top:1px solid #222;border-left:1px solid #222;} .subnav .nav>li+li>a:hover,.subnav .nav>li:first-child>a:hover{border-bottom:0;background-color:#33b5e5;}}'
      me = media code
      me.rules.length.should.equal 2
      me.rules[0].selectors.length.should.equal 2

    it 'parses rule after query', ->
      code = '@media (max-width:768px){div.subnav .nav>li+li>a,div.subnav .nav>li:first-child>a{border-top:1px solid #222;border-left:1px solid #222;} .subnav .nav>li+li>a:hover,.subnav .nav>li:first-child>a:hover{border-bottom:0;background-color:#33b5e5;}}.nav-list li>a{text-shadow:none;}'
      me = parser.parse code

  describe '#parse files', ->
    fs = require 'fs'
    parse = (content)-> parser.parse content

    it 'should parse bootstrap.min.css', ->
      me = parse fs.readFileSync('test/bootstrap.min.css').toString()
      me.length.should.equal 703

    it 'should parse cyborg.min.css', ->
      me = parse fs.readFileSync('test/cyborg.min.css').toString()
      me.length.should.equal 901

    it 'should parse slate.min.css', ->
      me = parse fs.readFileSync('test/slate.min.css').toString()
      me.length.should.equal 885

    it 'should parse amelia.min.css', ->
      me = parse fs.readFileSync('test/amelia.min.css').toString()
      me.length.should.equal 914

    it 'should parse demo.css', ->
      me = parse fs.readFileSync('test/demo.css').toString()
      me.length.should.equal 6

