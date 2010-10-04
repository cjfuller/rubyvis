$:.unshift(File.dirname(__FILE__)+"/../../lib")
require 'rubyvis'

# Nest yields data by site then year. */

barley = pv.nest(barley)
    .key(lambda {|d| d.site})
    .sort_keys(lambda {|a, b| site[b] - site[a]})
    .key(lambda {|d| d.year})
    .sort_values(function {|a, b| variety[b.variety] - variety[a.variety]})
    .entries()

# Sizing and scales. */
w = 332
h = 132
x = pv.Scale.linear(10, 90).range(0, w)
c = pv.Colors.category10()

# The root panel. */
var vis = new pv.Panel()
    .width(w)
    .height(h * pv.keys(site).length)
    .top(15.5)
    .left(0.5)
    .right(.5)
    .bottom(25);

# A panel per site-year. */
cell = vis.add(pv.Panel)
    .data(barley)
    .height(h)
    .left(90)
    .top(lambda { self.index * h})
    .strokeStyle("#999");

# Title bar. */
cell.add(pv.Bar)
    .height(14)
    .fillStyle("bisque")
  .anchor("center").add(pv.Label)
  .text(lambda{|site| site.key});

# A dot showing the yield. */
var dot = cell.add(pv.Panel)
.data(lambda {|site| site.values})
    .top(23)
  .add(pv.Dot)
  .data(lambda {|year| year.values})
  .left(lamdba {|d| x(d.yield)})
    .top(lambda {self.index * 11})
    .shapeSize(10)
    .lineWidth(2)
    .strokeStyle(lambda {|d| c(d.year)})

# A label showing the variety. */
dot.anchor("left").add(pv.Label)
  .visible(lambda { !self.parent.index})
  .left(-2)
  .text(lambda {|d| d.variety})

# X-ticks. */
vis.add(pv.Rule)
    .data(x.ticks())
    .left(lambda {|d| 90 + x.scale(d)})
    .bottom(-5)
    .height(5)
    .strokeStyle("#999")
  .anchor("bottom").add(pv.Label);

# A legend showing the year. */
vis.add(pv.Dot)
    .extend(dot)
    .data([{:year=>1931}, {:year=>1932}])
    .left(lambda {|d| 260 + self.index * 40})
    .top(-8)
  .anchor("right").add(pv.Label)
  .text(lambda {|d| d.year})

vis.render()