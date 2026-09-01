# Generates the README figures (images/*.png) and the thumbnail; the SVGs are intermediates written to a temp dir
#
#   ruby src/images.gen.rb
#
# Three graphs: Ruby <-> Python, JavaScript <-> Ruby <-> Python, and the logo with all 51 languages
# Needs rsvg-convert and the fonts listed below; anything missing is an error, so the pictures never change silently

require "set"
require "zlib"
require_relative "lib/langs"

IMG = File.join(__dir__, "..", "images")

# ---------------------------------------------------------------- parameters
# All numeric design choices live here
P = {
  # --- Poincare disk ---
  # Radius of the boundary circle (infinity) over the radius the nodes sit on
  # Near 1 the arcs dig toward the center (star-like); larger means closer to straight
  disk_ratio:       1.5,

  # --- logo radii ---
  # Bigger labels stretch the rim, so circles and mesh scale up too to keep the picture's share
  ring:           330.0,  # radius where rim node centers sit
  r_eso:           23.0,  # eso node radius
  r_node:          14.5,  # ordinary language node radius

  # --- clique mesh (all pairs of the 50 rim nodes) ---
  mesh_w:           0.4,  # stroke width
  mesh_op:          0.3,  # opacity

  # --- spokes from central Ruby to the rim (geodesics, hence straight) ---
  spoke_w:          2.2,  # for ordinary languages
  spoke_op:         0.5,
  spoke_head:       8.5,  # arrowhead length
  spoke_gap:        3.0,  # gap from node rim to arrowhead tip
  eso_spoke_w:      3.4,  # thicker for eso (the picture's skeleton)
  eso_spoke_head:  11.0,

  # --- pentagon sides (eso to eso) ---
  eso_w:            4.0,
  eso_head:        12.0,

  # --- rim neighbors ---
  # Same geodesics as the rest, but 7.2 degrees apart they come out as short near-straight arrows
  # Width and opacity alone lift them off the mesh (nodes are only ~38 apart, so heads stay small)
  nb_w:             2.0,  # thicker; if this is unreadable the rim order is unreadable
  nb_op:           0.92,
  nb_head:          3.4,  # arrowhead length (on both ends to show bidirectionality)
  nb_headw:         4.8,  # arrowhead width
  nb_gap:           1.0,  # gap from node rim to arrowhead tip

  # --- self-loops (the quine itself) ---
  loop_eso_r:      11.0,  # loop radius for eso
  loop_eso_w:       2.2,
  loop_eso_head:    7.5,
  loop_r:           8.5,  # for ordinary languages
  loop_w:           1.6,
  loop_head:        4.8,

  # --- logo labels ---
  ext_fs:          10.5,  # extension inside the circle (shrinks to fit)
  eso_ext_fs:      13.0,  # extension inside eso circles
  lab_gap:         48.0,  # rim node center to radial label start
  lab_fs:          23.0,  # ordinary language names (radial)
  eso_lab_gap:     52.0,  # eso circles are bigger, so slightly farther out
  eso_lab_fs:      26.0,
  hub_spider:       6.0,  # width of the spider as a multiple of GEM_R
  hub_gap:          4.0,  # arrows stop this far outside the spider's width
  title:        "A Clique of Quines",  # above the picture
  motto:        "ἓν τὸ πᾶν καὶ δι’ αὐτοῦ τὸ πᾶν καὶ εἰς αὐτὸ τὸ πᾶν",  # below it; the ouroboros inscription
  motto_em:         0.55, # GFS Philostratos is this much narrower than the ADV table (DejaVu Sans Bold)
  caption_fs:      72.0,
  title_gap:       44.0,  # between the topmost label and the title
  title_margin:    32.0,  # above the title
  motto_gap:       10.0,  # between the lowest label and the motto
  motto_fs:        40.0,  # the motto is meant to be unobtrusive
  motto_opacity:    0.9,
  source:       "— Κλεοπάτρης Χρυσοποιία",  # where the motto comes from (the folio's own heading), under it
  source_fs:       22.0,
  motto_right:     40.0,  # margin to the right of the motto and the source
  motto_margin:    56.0,  # below the motto
  hub_up:           0.04,  # the spider and its labels sit this much above the center (fraction of the spider width)
  hub_name_y:       0.205, # "Ruby" between the gem and the orbit arrow (baseline, fraction of the spider width)
  hub_file_y:       0.42, # "qc.rb" under the abdomen, between the hind legs

  # --- logo canvas ---
  pad:             18.0,  # margin from label reach to viewBox edge
  min_half:       420.0,  # lower bound of viewBox half-width
  logo_px:       1.3246,  # PNG pixels per viewBox unit (pixels grow as labels stretch the viewBox)

  # --- figure 1 (2 languages) ---
  f2_r:            52.0,  # node radius
  f2_dx:          170.0,  # horizontal offset from center
  f2_bow:         180.0,  # bulge of the round-trip arcs (control point height)
  f2_w:             3.0,
  f2_head:         11.0,
  f2_loop_r:       30.0,
  f2_file_fs:      30.0,  # file name inside the circle
  f2_name_fs:      15.0,  # language name inside the circle
  f2_cmd_fs:       18.0,  # command labels

  # --- figure 2 (3 languages) ---
  f3_r:            50.0,
  f3_dx:          280.0,
  f3_w:             3.0,
  f3_head:         11.0,
  f3_loop_r:       28.0,
  f3_file_fs:      28.0,
  f3_name_fs:      14.0,
  f3_cmd_fs:       16.0,
}.freeze

# Circles show only the extension, so display names live here
NAMES = {
  "rb" => "Ruby", "py" => "Python", "js" => "JavaScript", "ts" => "TypeScript",
  "pl" => "Perl", "php" => "PHP", "lua" => "Lua", "r" => "R", "bash" => "Bash",
  "scm" => "Scheme", "tcl" => "Tcl", "c" => "C", "cpp" => "C++",
  "cr" => "Crystal", "cs" => "C#", "d" => "D", "f90" => "Fortran", "go" => "Go",
  "java" => "Java", "kt" => "Kotlin", "nim" => "Nim", "pas" => "Pascal",
  "rs" => "Rust", "swift" => "Swift", "zig" => "Zig", "clj" => "Clojure",
  "groovy" => "Groovy", "ml" => "OCaml", "exs" => "Elixir", "fs" => "Forth",
  "lisp" => "Common Lisp", "octave" => "Octave", "coffee" => "CoffeeScript",
  "vala" => "Vala", "hx" => "Haxe", "pike" => "Pike", "fsx" => "F#",
  "awk" => "AWK", "erl" => "Erlang", "prolog" => "Prolog", "ps" => "PostScript",
  "hs" => "Haskell", "sml" => "Standard ML", "rkt" => "Racket",
  "scala" => "Scala", "m" => "Objective-C",
  "bf" => "brainfuck", "bef" => "Befunge", "ws" => "Whitespace",
  "piet" => "Piet", "unl" => "Unlambda",
}.freeze

# The five eso members at the pentagon vertices (clockwise from the top)
ESO = %w[bf piet bef ws unl].freeze
HUB = "rb"

KEYS = Lang::MEMBERS.map(&:key)
missing = KEYS - NAMES.keys
raise "members missing from NAMES: #{missing.join(" ")}" unless missing.empty?
raise "non-members in ESO: #{(ESO - KEYS).join(" ")}" unless (ESO - KEYS).empty?
REST = (KEYS - [HUB] - ESO).sort_by { |k| NAMES[k].downcase }  # clockwise from brainfuck, alphabetically

# Colors
BG      = "#161a20"  # background of the PNGs
C_MESH  = "#78889a"  # clique mesh
C_NB    = "#e0b341"  # rim neighbors
C_LOOP  = "#e0b341"  # self-loops (big circles)
C_LOOP2 = "#c9791a"  # self-loops (small circles)
C_RUBY  = "#ad1f2c"  # Ruby (the gem and the spider)
C_RB_E  = "#f0263f"  # arrows out of Ruby
C_ESO   = "#12707f"  # eso circles
C_ESO_E = "#1c7c8c"  # arrows between eso members
C_NAME  = "#2f8d9c"  # eso names
C_NODE  = "#67727f"  # ordinary language circles
C_DIM   = "#7d8b9b"  # ordinary language names
# Fonts, one family each with no fallback (Raleway and UnifrakturCook: Google Fonts, GFS Solomos: Greek Font Society)
FONT  = "Raleway"           # names
MONO  = "DejaVu Sans Mono"  # command lines
TITLE = "UnifrakturCook"    # blackletter for the title
MOTTO = "GFS Solomos"       # an italic Greek face for the motto
[FONT, MONO, TITLE, MOTTO].each do |family|
  raise "font not installed: #{family}" unless system("fc-list", "-q", ":family=#{family}")
end

RAD = Math::PI / 180

def f(v) = format("%g", (v * 100).round / 100.0)
def esc(s) = s.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
def pt(r, deg) = [r * Math.cos(deg * RAD), r * Math.sin(deg * RAD)]
def unit(dx, dy) = (h = Math.hypot(dx, dy)).zero? ? [0, 0] : [dx / h, dy / h]

# Approximate advance widths in em units (measured on DejaVu Sans Bold; Raleway is a little narrower, so fits err safe)
# A flat 0.6em per character is off by ~10% on ".groovy", too coarse for fit decisions
ADV = Hash.new(0.64).merge(
  "." => 0.33, "+" => 0.72, "#" => 0.78,
  "i" => 0.34, "l" => 0.34, "j" => 0.34, "f" => 0.42, "t" => 0.46, "r" => 0.47,
  "m" => 0.98, "w" => 0.83, "s" => 0.56, "c" => 0.55, "z" => 0.53, "v" => 0.60,
  "y" => 0.60, "x" => 0.60, "e" => 0.62, "a" => 0.64, "R" => 0.70, "C" => 0.70,
).freeze

def text_em(txt) = txt.each_char.sum { |ch| ADV[ch] }
def text_w(txt, fs) = text_em(txt) * fs

# Font size fitting width max_w: kept as is if it fits, shrunk just enough otherwise
def fit_fs(txt, fs, max_w) = [fs, max_w / text_em(txt)].min

# Gem shape: Ruby's node in the small figures
GEM = [[-27.14, -38.95], [27.14, -38.95], [46.8, -12.74], [0, 42.48], [-46.8, -12.74]].freeze
GEM_R = 47.0

def gem_shape(cx, cy, s)
  pts = GEM.map { |x, y| "#{f cx + x * s},#{f cy + y * s}" }.join(" ")
  %(<polygon points="#{pts}" fill="#{C_RUBY}"/>)
end

# Distance from the center along direction deg to the gem outline
def gem_radius(deg, s = 1.0)
  dx, dy = Math.cos(deg * RAD), Math.sin(deg * RAD)
  best = nil
  GEM.each_with_index do |p, i|
    q = GEM[(i + 1) % GEM.size]
    ax, ay = p[0] * s, p[1] * s
    ex, ey = q[0] * s - ax, q[1] * s - ay
    den = dx * ey - dy * ex
    next if den.abs < 1e-12
    t = (ax * ey - ay * ex) / den
    u = (ax * dy - ay * dx) / den
    best = t if t > 0 && u >= -1e-9 && u <= 1 + 1e-9 && (best.nil? || t < best)
  end
  best || GEM_R * s
end

# The spider at the hub: images/spider.svg (the body, a gem on the abdomen, and its own self-loop arrow)
# The file colors the gem and the arrow via classes st7 / st6 and leaves the body unfilled; recolor here
SPIDER = File.read(File.join(IMG, "spider.svg"))

def spider(cx, cy, width, body, arrow)
  vb = SPIDER[/viewBox="([^"]+)"/, 1].split.map(&:to_f)
  inner = SPIDER[%r{<svg[^>]*>(.*)</svg>}m, 1].sub(%r{<defs>.*</defs>}m, "")
                .gsub('class="st7"', 'fill="#ffffff"').gsub('class="st6"', %(fill="#{arrow}"))
  s = width / vb[2]
  %(<g transform="translate(#{f cx - vb[2] * s / 2} #{f cy - vb[3] * s / 2}) scale(#{f s})" fill="#{body}">#{inner}</g>)
end

# Circles: the plain radius; the gem: distance to its outline in that direction
def node_r(n, deg) = n[:gem] ? gem_radius(deg, n[:gem]) : n[:r]

# Half-width of the gem outline at dy below the center
# The gem narrows upward, so text fit is measured at the top edge of the text
def gem_halfw(dy, s = 1.0)
  ys = dy / s
  xs = []
  GEM.each_with_index do |p, i|
    q = GEM[(i + 1) % GEM.size]
    next if (p[1] > ys) == (q[1] > ys)
    xs << p[0] + (ys - p[1]) / (q[1] - p[1]) * (q[0] - p[0])
  end
  xs.empty? ? 0.0 : (xs.max - xs.min) / 2.0 * s
end

def text(x, y, str, size:, fill:, weight: 700, anchor: "middle", font: FONT, opacity: nil, rot: nil)
  a = %(<text x="#{f x}" y="#{f y}" font-family="'#{font}'" font-size="#{f size}")
  a += %( font-weight="#{weight}" fill="#{fill}" text-anchor="#{anchor}")
  a += %( dominant-baseline="central")
  a += %( opacity="#{opacity}") if opacity
  a += %( transform="rotate(#{f rot} #{f x} #{f y})") if rot
  a + ">#{esc str}</text>"
end

# Radial name outside the circle (the left half rotated 180 so it runs outward)
# Returns the SVG and the radius the label tip reaches; the viewBox is sized from this reach
def radial_label(name, deg, r, fill, size)
  x, y = pt(r, deg)
  reach = r + text_w(name, size)
  svg = if Math.cos(deg * RAD) >= 0
          text(x, y, name, size:, fill:, anchor: "start", rot: deg)
        else
          text(x, y, name, size:, fill:, anchor: "end", rot: deg + 180)
        end
  [svg, reach]
end

# How far the line sinks into the arrowhead before stopping (fraction from the tip)
# Drawn to the very end, the round stroke cap would poke past the head and blunt the tip
HEAD_BITE = 0.6

# Triangle with its tip at (x,y), pointing along (dx,dy)
def head(x, y, dx, dy, size, fill, opacity = 1, halfw = nil)
  ux, uy = unit(dx, dy)
  bx, by = x - ux * size, y - uy * size
  w = halfw || size * 0.46
  pts = ["#{f x},#{f y}", "#{f bx - uy * w},#{f by + ux * w}", "#{f bx + uy * w},#{f by - ux * w}"]
  %(<polygon points="#{pts.join(" ")}" fill="#{fill}"#{opacity < 1 ? %( fill-opacity="#{opacity}") : ""}/>)
end

# ---------------------------------------------------------------- geodesics
# A Poincare disk geodesic: the arc through two points at radius rho, orthogonal to the boundary circle
# R = rho * disk_ratio; nodes sit inside the boundary, so a larger disk_ratio gives a shallower sag
# Returns [arc center x, y, radius, start angle, end angle, sweep] (nil for a diameter)
def geo_params(rho, a1, a2)
  d = (a2 - a1) % 360
  d -= 360 if d > 180
  return nil if (d.abs - 180).abs < 0.01 || d.abs < 0.01
  half = d.abs / 2.0
  rr = rho * P[:disk_ratio]
  c = (rho * rho + rr * rr) / (2 * rho * Math.cos(half * RAD))  # distance to the arc center, along the bisector
  ar = Math.sqrt(c * c - rr * rr)
  cx, cy = pt(c, a1 + d / 2.0)
  p1, p2 = pt(rho, a1), pt(rho, a2)
  t1 = Math.atan2(p1[1] - cy, p1[0] - cx) / RAD
  t2 = Math.atan2(p2[1] - cy, p2[0] - cx) / RAD
  dt = (t2 - t1) % 360
  dt -= 360 if dt > 180
  [cx, cy, ar, t1, t2, dt]
end

# Geodesic for the mesh, with untrimmed ends
def geodesic(rho, a1, a2)
  p1, p2 = pt(rho, a1), pt(rho, a2)
  g = geo_params(rho, a1, a2)
  return %(<path d="M#{f p1[0]} #{f p1[1]}L#{f p2[0]} #{f p2[1]}"/>) unless g
  _, _, ar, _, _, dt = g
  %(<path d="M#{f p1[0]} #{f p1[1]}A#{f ar} #{f ar} 0 0 #{dt > 0 ? 1 : 0} #{f p2[0]} #{f p2[1]}"/>)
end

# Geodesic edge, trimmed by the node radii, with arrowheads
def geo_arrow(rho, a1, a2, r1, r2, color, width, both: false, hsize: 9, gap: 4, opacity: 1, headw: nil)
  g = geo_params(rho, a1, a2)
  unless g
    x1, y1 = pt(rho, a1)
    x2, y2 = pt(rho, a2)
    return arrow({ x: x1, y: y1, r: r1 }, { x: x2, y: y2, r: r2 }, color, width,
                 both:, hsize:, gap:, opacity:)
  end
  cx, cy, ar, t1, t2, dt = g
  sg = dt > 0 ? 1 : -1
  span = ->(d) { 2 * Math.asin([d / (2 * ar), 1.0].min) / RAD }  # central angle subtending chord length d
  s1, s2 = span[r1 + gap], span[r2 + gap]
  k = [1.0, dt.abs / (s1 + s2)].min            # squeeze so the tips do not cross when nodes are close
  u1, u2 = t1 + sg * s1 * k, t2 - sg * s2 * k  # arrowhead tip positions
  bite = [span[hsize * HEAD_BITE], (dt.abs - (s1 + s2) * k) / (both ? 2 : 1)].min
  v1 = both ? u1 + sg * bite : u1              # line stops inside the arrowhead
  v2 = u2 - sg * bite
  at = ->(u) { [cx + ar * Math.cos(u * RAD), cy + ar * Math.sin(u * RAD)] }
  sx, sy = at[v1]
  ex, ey = at[v2]
  out = [%(<path d="M#{f sx} #{f sy}A#{f ar} #{f ar} 0 0 #{sg > 0 ? 1 : 0} #{f ex} #{f ey}") +
         %( fill="none" stroke="#{color}" stroke-width="#{f width}") +
         %( stroke-opacity="#{opacity}" stroke-linecap="butt"/>)]
  hw = headw && headw / 2
  hx, hy = at[u2]
  out << head(hx, hy, -Math.sin(u2 * RAD) * sg, Math.cos(u2 * RAD) * sg, hsize, color, opacity, hw)
  if both
    hx, hy = at[u1]
    out << head(hx, hy, Math.sin(u1 * RAD) * sg, -Math.cos(u1 * RAD) * sg, hsize, color, opacity, hw)
  end
  out
end

# On the gem the outline dips with direction, so take the loop base slightly inside
def loop_r(n, deg)
  return n[:r] unless n[:gem]
  [-24, 0, 24].map { |o| gem_radius(deg + o, n[:gem]) }.min
end

# Self-loop sticking out of the node (marks a quine)
def self_loop(n, deg, lr, color, width, hsize)
  px, py, nr = n[:x], n[:y], loop_r(n, deg)
  ux, uy = pt(1, deg)
  dd = nr + lr * 0.6
  qx, qy = px + ux * dd, py + uy * dd
  cosphi = (dd * dd + lr * lr - nr * nr) / (2 * dd * lr)
  cosphi = cosphi.clamp(-1.0, 1.0)
  phi = Math.acos(cosphi) / RAD
  back = deg + 180
  sx, sy = qx + lr * Math.cos((back + phi) * RAD), qy + lr * Math.sin((back + phi) * RAD)
  ex, ey = qx + lr * Math.cos((back - phi) * RAD), qy + lr * Math.sin((back - phi) * RAD)
  bite = hsize * HEAD_BITE / lr / RAD  # line stops inside the arrowhead
  tip = back - phi
  px, py = qx + lr * Math.cos((tip - bite) * RAD), qy + lr * Math.sin((tip - bite) * RAD)
  path = %(<path d="M#{f sx} #{f sy}A#{f lr} #{f lr} 0 1 1 #{f px} #{f py}" ) +
         %(fill="none" stroke="#{color}" stroke-width="#{f width}" stroke-linecap="butt"/>)
  tx, ty = -Math.sin(tip * RAD), Math.cos(tip * RAD)
  [path, head(ex, ey, tx, ty, hsize, color)]
end

# Point gap away from node n's outline, in direction deg
def rim(n, deg, gap = 4)
  ux, uy = pt(1, deg)
  [n[:x] + ux * (node_r(n, deg) + gap), n[:y] + uy * (node_r(n, deg) + gap)]
end

# Quadratic Bezier edge through control point c, trimmed at the outlines, arrowhead at the end
# Returns the SVG and the apex [x, y] for label placement
def quad_edge(a, b, c, color, width, hsize, gap: 4)
  sx, sy = rim(a, Math.atan2(c[1] - a[:y], c[0] - a[:x]) / RAD, gap)
  edeg = Math.atan2(c[1] - b[:y], c[0] - b[:x]) / RAD
  ex, ey = rim(b, edeg, gap)
  px, py = rim(b, edeg, gap + hsize * HEAD_BITE)  # line stops inside the arrowhead
  out = [%(<path d="M#{f sx} #{f sy}Q#{f c[0]} #{f c[1]} #{f px} #{f py}" fill="none") +
         %( stroke="#{color}" stroke-width="#{f width}" stroke-linecap="butt"/>)]
  out << head(ex, ey, ex - c[0], ey - c[1], hsize, color)
  [out, [(sx + 2 * c[0] + ex) / 4.0, (sy + 2 * c[1] + ey) / 4.0]]
end

# Cubic Bezier edge; exit sdeg and entry edeg are free, which suits the wide detours
def cubic_edge(a, b, sdeg, edeg, c1, c2, color, width, hsize)
  sx, sy = rim(a, sdeg)
  ex, ey = rim(b, edeg)
  px, py = rim(b, edeg, 4 + hsize * HEAD_BITE)  # line stops inside the arrowhead
  out = [%(<path d="M#{f sx} #{f sy}C#{f c1[0]} #{f c1[1]} #{f c2[0]} #{f c2[1]} ) +
         %(#{f px} #{f py}" fill="none" stroke="#{color}" stroke-width="#{f width}") +
         %( stroke-linecap="butt"/>)]
  out << head(ex, ey, ex - c2[0], ey - c2[1], hsize, color)
  apex = [0, 1].map { |i| ([sx, sy][i] + 3 * c1[i] + 3 * c2[i] + [ex, ey][i]) / 8.0 }
  [out, apex]
end

# Straight edge from node a to b (both true puts arrowheads on both ends = bidirectional)
def arrow(a, b, color, width, both: false, hsize: 9, gap: 4, opacity: 1)
  ux, uy = unit(b[:x] - a[:x], b[:y] - a[:y])
  deg = Math.atan2(uy, ux) / RAD
  ra, rb = node_r(a, deg), node_r(b, deg + 180)
  sx, sy = a[:x] + ux * (ra + gap), a[:y] + uy * (ra + gap)
  ex, ey = b[:x] - ux * (rb + gap), b[:y] - uy * (rb + gap)
  bite = hsize * HEAD_BITE  # line stops inside the arrowhead
  px, py = ex - ux * bite, ey - uy * bite
  qx, qy = both ? [sx + ux * bite, sy + uy * bite] : [sx, sy]
  out = [%(<path d="M#{f qx} #{f qy}L#{f px} #{f py}" fill="none" stroke="#{color}") +
         %( stroke-width="#{f width}" stroke-opacity="#{opacity}" stroke-linecap="butt"/>)]
  out << head(ex, ey, ux, uy, hsize, color)
  out << head(sx, sy, -ux, -uy, hsize, color) if both
  out
end

def svg(view, body, title, desc)
  x, y, w, h = view
  <<~SVG
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="#{f x} #{f y} #{f w} #{f h}" width="#{f w}" height="#{f h}" font-family="'#{FONT}'">
    <title>#{esc title}</title>
    <desc>#{esc desc}</desc>
    #{body.flatten.join("\n")}
    </svg>
  SVG
end

require "tmpdir"
SVG_DIR = Dir.mktmpdir("quine-clique-images")  # the SVGs are intermediates; only the PNGs go to images/

def write(name, view, body, title, desc, png_width)
  path = File.join(SVG_DIR, "#{name}.svg")
  File.write(path, svg(view, body, title, desc))
  puts "#{path}: #{f view[2]} x #{f view[3]}"
  render(name, png_width)
end

RSVG = `which rsvg-convert 2>/dev/null`.chomp
raise "rsvg-convert not installed" if RSVG.empty?

def render(name, width)
  out = File.join(IMG, "#{name}.png")
  system(RSVG, "-b", BG, "-w", width.to_s, File.join(SVG_DIR, "#{name}.svg"), "-o", out) or
    raise "rsvg-convert failed: #{out}"
  puts "  #{out}"
end

# Big node for the 2 / 3-language figures: full file name over a small language name, both inside
# With the command labels this reads directly as "run qc.rb under ruby and out comes qc.py"
def big_node(key, x, y, r, file_size, name_size)
  file = "qc.#{key}"
  out = []
  if key == HUB
    s = r / GEM_R
    # The gem tapers, so measure the fit where the text's top edge sits (bigger text hits the shoulders)
    fy, ny = y - 13 * s, y + 9 * s
    fs = fit_fs(file, file_size, 2 * gem_halfw(-13 * s - 0.55 * file_size, s) - 6)
    out << gem_shape(x, y, s)
    out << text(x, fy, file, size: fs, fill: "#ffffff")
    out << text(x, ny, NAMES[key], size: name_size, fill: "#ffffff", weight: 500, opacity: "0.82")
  else
    # Circles also narrow upward, so measure the fit at the text's top edge as with the gem
    dy = r * 0.17 + 0.55 * file_size
    fs = fit_fs(file, file_size, 2 * Math.sqrt([r * r - dy * dy, 1.0].max) - 6)
    out << %(<circle cx="#{f x}" cy="#{f y}" r="#{f r}" fill="#{C_ESO}"/>)
    out << text(x, y - r * 0.17, file, size: fs, fill: "#ffffff")
    out << text(x, y + r * 0.30, NAMES[key], size: name_size, fill: "#ffffff", weight: 500, opacity: "0.85")
  end
  out
end

########################################################################
# Figure 1: Ruby <-> Python
# Labels go on the edges (print the other, given an argument) and the self-loops (print itself, given none)
########################################################################

def figure2
  r = P[:f2_r]
  rb = { x: -P[:f2_dx], y: 0.0, r: r, gem: r / GEM_R }
  py = { x: P[:f2_dx], y: 0.0, r: r }
  body = []

  # The round trip as two arcs (rb -> py on top, py -> rb below)
  [[rb, py, -P[:f2_bow], C_RB_E, "ruby qc.rb py"],
   [py, rb, P[:f2_bow], C_ESO_E, "python3 qc.py rb"]].each do |a, b, cy, col, label|
    cx = 0.0
    sux, suy = unit(cx - a[:x], cy - a[:y])
    eux, euy = unit(cx - b[:x], cy - b[:y])
    sr = node_r(a, Math.atan2(suy, sux) / RAD)
    er = node_r(b, Math.atan2(euy, eux) / RAD)
    sx, sy = a[:x] + sux * (sr + 3), a[:y] + suy * (sr + 3)
    ex, ey = b[:x] + eux * (er + 3), b[:y] + euy * (er + 3)
    bite = P[:f2_head] * HEAD_BITE  # line stops inside the arrowhead
    hx, hy = b[:x] + eux * (er + 3 + bite), b[:y] + euy * (er + 3 + bite)
    body << %(<path d="M#{f sx} #{f sy}Q#{f cx} #{f cy} #{f hx} #{f hy}" fill="none") +
            %( stroke="#{col}" stroke-width="#{f P[:f2_w]}" stroke-linecap="butt"/>)
    body << head(ex, ey, ex - cx, ey - cy, P[:f2_head], col)
    apex = (sy + 2 * cy + ey) / 4.0
    body << text(0, apex + (cy < 0 ? -17 : 17), label, size: P[:f2_cmd_fs], fill: col,
                 weight: 700, font: MONO)
  end

  # Self-loops (each file is a quine by itself)
  # Their labels stretch sideways, and the viewBox is sized from that reach (bigger text never clips)
  reach = 0.0
  [[rb, 180.0, "ruby qc.rb", "end"], [py, 0.0, "python3 qc.py", "start"]].each do |n, deg, label, anchor|
    body << self_loop(n, deg, P[:f2_loop_r], C_LOOP, P[:f2_w], P[:f2_head])
    lx = n[:x] + Math.cos(deg * RAD) * (loop_r(n, deg) + P[:f2_loop_r] * 1.6 + 14)
    body << text(lx, 0, label, size: P[:f2_cmd_fs], fill: C_LOOP2, weight: 700, anchor:, font: MONO)
    reach = [reach, lx.abs + text_w(label, P[:f2_cmd_fs])].max
  end

  body << big_node(HUB, rb[:x], rb[:y], r, P[:f2_file_fs], P[:f2_name_fs])
  body << big_node("py", py[:x], py[:y], r, P[:f2_file_fs], P[:f2_name_fs])

  half = reach + P[:pad]
  write("multiquine-rb-py", [-half, -150, 2 * half, 300], body,
        "Ruby <-> Python",
        "qc.rb and qc.py are each a quine, yet print each other when given an argument",
        (2 * half * 2).round(-1))
end

########################################################################
# Figure 2: JavaScript <-> Ruby <-> Python in a row
# One-way labeled arrows as in figure 1: rightward on top (js -> rb -> py), leftward below (py -> rb -> js)
# Only the top half is given in numbers; the bottom is its 180-degree rotation, so the figure is point-symmetric
########################################################################

def figure3
  r = P[:f3_r]
  js = { x: -P[:f3_dx], y: 0.0, r: r }
  rb = { x: 0.0, y: 0.0, r: r, gem: r / GEM_R }
  py = { x: P[:f3_dx], y: 0.0, r: r }
  body = []
  rot = ->(p) { [-p[0], -p[1]] }  # 180-degree rotation about the center
  mate = ->(n) { n.equal?(js) ? py : n.equal?(py) ? js : rb }

  # The four neighbor edges (write the top two; the bottom two are their rotations)
  # Arrow color follows the source node
  # Label x is nudged by hand; at the arc apex it would hit Ruby's self-loop
  [[js, rb, [-140.0, -80.0], -168.0, C_ESO_E, "node qc.js rb", "python3 qc.py rb"],
   [rb, py, [140.0, -80.0], 140.0, C_RB_E, "ruby qc.rb py", "ruby qc.rb js"]].each do |a, b, c, lx, col, up, down|
    edge, apex = quad_edge(a, b, c, col, P[:f3_w], P[:f3_head], gap: 8)
    body << edge
    ly = apex[1] - 19
    body << text(lx, ly, up, size: P[:f3_cmd_fs], fill: col, weight: 700, font: MONO)
    edge, = quad_edge(mate[a], mate[b], rot[c], col, P[:f3_w], P[:f3_head], gap: 8)
    body << edge
    body << text(-lx, -ly, down, size: P[:f3_cmd_fs], fill: col, weight: 700, font: MONO)
  end

  # The two end-to-end edges, leaving from the outer sides and swinging wide around Ruby
  # Again top written, bottom rotated (exit/entry angles must rotate too or the bulges differ)
  [[js, py, -125.0, -55.0, [-390.0, -215.0], [390.0, -215.0], C_ESO_E,
    "node qc.js py", "python3 qc.py js"]].each do |a, b, sd, ed, c1, c2, col, up, down|
    edge, apex = cubic_edge(a, b, sd, ed, c1, c2, col, P[:f3_w], P[:f3_head])
    body << edge
    ly = apex[1] - 20
    body << text(0, ly, up, size: P[:f3_cmd_fs], fill: col, weight: 700, font: MONO)
    edge, = cubic_edge(mate[a], mate[b], sd + 180, ed + 180, rot[c1], rot[c2], col,
                       P[:f3_w], P[:f3_head])
    body << edge
    body << text(0, -ly, down, size: P[:f3_cmd_fs], fill: col, weight: 700, font: MONO)
  end

  # Self-loops escape toward unused directions; all three go unlabeled (labels would crowd)
  body << self_loop(js, 180.0, P[:f3_loop_r], C_LOOP, 2.8, 10)
  # The gem's flat top would bury the arrowhead, so treat just the base as a circle
  body << self_loop({ x: rb[:x], y: rb[:y], r: GEM_R }, -90.0, 26, C_LOOP, 2.8, 10)
  body << self_loop(py, 0.0, P[:f3_loop_r], C_LOOP, 2.8, 10)

  body << big_node("js", js[:x], js[:y], r, P[:f3_file_fs], P[:f3_name_fs])
  body << big_node(HUB, rb[:x], rb[:y], r, P[:f3_file_fs], P[:f3_name_fs])
  body << big_node("py", py[:x], py[:y], r, P[:f3_file_fs], P[:f3_name_fs])

  write("multiquine-rb-py-js", [-420, -225, 840, 450], body,
        "JavaScript <-> Ruby <-> Python",
        "Three quines that print one another depending on the argument", 1680)
end

########################################################################
# Figure 3: the logo (51 languages)
# Rim slots 0/10/20/30/40 hold the eso members, with nine of the other 45 languages between each pair
# The rim is an all-pairs mesh; only pentagon sides and neighbor pairs leave it as thick colored arrows
########################################################################

def logo
  ring = P[:ring]
  # Eso members evenly spaced on the rim, ordinary languages filling the gaps (45 / 5 = 9 each)
  # On uneven division earlier gaps take one extra, so the layout survives member changes
  slots = ESO.size + REST.size
  per, extra = REST.size.divmod(ESO.size)
  rest = REST.dup
  order = []
  ESO.each_with_index do |k, i|
    order << k
    (per + (i < extra ? 1 : 0)).times { order << rest.shift }
  end
  raise "rim slot assignment mismatch" unless rest.empty? && order.size == slots
  step = 360.0 / slots

  ang = Array.new(slots) { |i| -90.0 + step * i }
  big = ESO.to_h { |k| [k, true] }
  nr = ->(k) { big[k] ? P[:r_eso] : P[:r_node] }
  node = ->(i) { x, y = pt(ring, ang[i]); { x: x, y: y, r: nr[order[i]] } }
  eso_idx = ESO.map { |k| order.index(k) }
  pent = eso_idx.each_cons(2).to_a.push([eso_idx.last, eso_idx.first])
  nb = (0...slots).map { |i| [i, (i + 1) % slots].sort }  # rim neighbors
  skip = (pent.map(&:sort) + nb).to_set                   # pairs excluded from the mesh
  body = []

  # Clique mesh: all pairs of the 50 rim nodes minus pentagon sides and neighbor pairs
  body << %(<g fill="none" stroke="#{C_MESH}" stroke-width="#{f P[:mesh_w]}" ) +
          %(stroke-opacity="#{P[:mesh_op]}" stroke-linecap="round">)
  mesh = 0
  (0...slots).to_a.combination(2) do |i, j|
    next if skip.include?([i, j])
    mesh += 1
    body << geodesic(ring, ang[i], ang[j])
  end
  body << "</g>"

  # Rim neighbors (the same geodesics, but 7.2 degrees apart they are short and near straight)
  nb.each do |i, j|
    body << geo_arrow(ring, ang[i], ang[j], nr[order[i]], nr[order[j]], C_NB, P[:nb_w],
                      both: true, hsize: P[:nb_head], gap: P[:nb_gap], opacity: P[:nb_op],
                      headw: P[:nb_headw])
  end

  # Ruby to the 45 ordinary languages (geodesics through the center, hence straight)
  spider_w = GEM_R * P[:hub_spider]
  hub = { x: 0.0, y: 0.0, r: spider_w / 2 + P[:hub_gap] }
  slots.times do |i|
    next if big[order[i]]
    body << arrow(hub, node[i], C_RB_E, P[:spoke_w], both: true, hsize: P[:spoke_head],
                  gap: P[:spoke_gap], opacity: P[:spoke_op])
  end

  # Pentagon sides and Ruby-to-eso spokes (the part to emphasize)
  pent.each do |i, j|
    body << geo_arrow(ring, ang[i], ang[j], nr[order[i]], nr[order[j]], C_ESO_E, P[:eso_w],
                      both: true, hsize: P[:eso_head], gap: 4)
  end
  eso_idx.each do |i|
    body << arrow(hub, node[i], C_ESO_E, P[:eso_spoke_w], both: true,
                  hsize: P[:eso_spoke_head], gap: 4)
  end

  # Self-loops
  slots.times do |i|
    k = order[i]
    body << self_loop(node[i], ang[i], big[k] ? P[:loop_eso_r] : P[:loop_r],
                      big[k] ? C_LOOP : C_LOOP2, big[k] ? P[:loop_eso_w] : P[:loop_w],
                      big[k] ? P[:loop_eso_head] : P[:loop_head])
  end

  # Circles hold only the extension (fifty "qc." repeats would be noise; the leading . marks it)
  slots.times do |i|
    n = node[i]
    k = order[i]
    body << %(<circle cx="#{f n[:x]}" cy="#{f n[:y]}" r="#{f n[:r]}" fill="#{big[k] ? C_ESO : C_NODE}"/>)
    ext = "." + k
    body << text(n[:x], n[:y], ext, fill: "#ffffff",
                 size: fit_fs(ext, big[k] ? P[:eso_ext_fs] : P[:ext_fs], 2 * n[:r] - 4))
  end
  dy = -spider_w * P[:hub_up]
  body << spider(0, dy, spider_w, C_RUBY, C_LOOP)
  body << text(0, dy + spider_w * P[:hub_name_y], NAMES[HUB], size: P[:lab_fs], fill: "#ffffff")
  body << text(0, dy + spider_w * P[:hub_file_y], "qc." + HUB, size: P[:eso_ext_fs], fill: "#ffffff", opacity: "0.85")

  # All 50 rim names radiate outward (the left half rotated 180 so none read upside down)
  # The five eso names follow the same rule, set apart only by size and color
  reach = below = above = 0.0
  slots.times do |i|
    k = order[i]
    gap, fs, col = big[k] ? [P[:eso_lab_gap], P[:eso_lab_fs], C_NAME] : [P[:lab_gap], P[:lab_fs], C_DIM]
    svg, far = radial_label(NAMES[k], ang[i], ring + gap, col, fs)
    body << svg
    reach = [reach, far].max
    below = [below, far * Math.sin(ang[i] * RAD)].max
    above = [above, -far * Math.sin(ang[i] * RAD)].max
  end

  # Margins come from measured label reach, so nothing clips as members come and go
  # The PNG scales with the viewBox, so pixel density stays constant as text grows
  half = [reach + P[:pad], P[:min_half]].max

  # Title right above the topmost label, motto right under the lowest one (0.75 em = cap height, 0.3 em = descent)
  fs = P[:caption_fs]
  title_y = -(above + P[:title_gap])
  mfs = fit_fs(P[:motto], P[:motto_fs], (2 * half - 2 * P[:pad]) / P[:motto_em])
  motto_y = below + P[:motto_gap] + mfs * 0.75
  body << text(0, title_y, P[:title], size: fs, fill: "#e8edf2", weight: 700, font: TITLE)
  body << text(half - P[:motto_right], motto_y, P[:motto], size: mfs, fill: "#c2cdd8", weight: 400, font: MOTTO,
               opacity: P[:motto_opacity], anchor: "end")
  source_y = motto_y + P[:source_fs] * 1.5
  body << text(half - P[:motto_right], source_y, P[:source], size: P[:source_fs], fill: "#c2cdd8", weight: 400, font: MOTTO,
               opacity: 0.7, anchor: "end")
  top = title_y - fs * 0.75 - P[:title_margin]
  bottom = source_y + P[:source_fs] * 0.3 + P[:motto_margin]
  write("logo", [-half, top, 2 * half, bottom - top], body,
        "quine-clique",
        "Complete graph K#{KEYS.size} of #{KEYS.size} languages plus self-loops. Ruby at the center, " +
        ESO.map { |k| NAMES[k] }.join(" / ") +
        " at the pentagon vertices, and #{per} each of the other #{REST.size} languages between them",
        (2 * half * P[:logo_px]).round(-1))
  warn "logo: nodes=#{slots + 1} K#{slots + 1}=#{(slots + 1) * slots / 2} " \
       "[mesh #{mesh} + neighbor #{nb.size} + pentagon #{pent.size} + spoke #{slots}] " \
       "selfloops=#{slots + 1} half=#{f half}"
end

# ---- thumbnail: images/thumbnail.png, qc.rb drawn in the IBM VGA 8x16 font (CP437) ----
# Glyphs extracted from the vgabios font table (16 bytes per char, top row in the high byte)

GLYPHS = {
   32 => 0x00000000000000000000000000000000,  33 => 0x0000183C3C3C18181800181800000000,
   34 => 0x00666666240000000000000000000000,  35 => 0x0000006C6CFE6C6C6CFE6C6C00000000,
   36 => 0x18187CC6C2C07C060686C67C18180000,  37 => 0x00000000C2C60C183060C68600000000,
   38 => 0x0000386C6C3876DCCCCCCC7600000000,  39 => 0x00303030600000000000000000000000,
   40 => 0x00000C18303030303030180C00000000,  41 => 0x000030180C0C0C0C0C0C183000000000,
   42 => 0x0000000000663CFF3C66000000000000,  43 => 0x000000000018187E1818000000000000,
   44 => 0x00000000000000000018181830000000,  45 => 0x00000000000000FE0000000000000000,
   46 => 0x00000000000000000000181800000000,  47 => 0x0000000002060C183060C08000000000,
   48 => 0x00003C66C3C3DBDBC3C3663C00000000,  49 => 0x00001838781818181818187E00000000,
   50 => 0x00007CC6060C183060C0C6FE00000000,  51 => 0x00007CC606063C060606C67C00000000,
   52 => 0x00000C1C3C6CCCFE0C0C0C1E00000000,  53 => 0x0000FEC0C0C0FC060606C67C00000000,
   54 => 0x00003860C0C0FCC6C6C6C67C00000000,  55 => 0x0000FEC606060C183030303000000000,
   56 => 0x00007CC6C6C67CC6C6C6C67C00000000,  57 => 0x00007CC6C6C67E0606060C7800000000,
   58 => 0x00000000181800000018180000000000,  59 => 0x00000000181800000018183000000000,
   60 => 0x000000060C18306030180C0600000000,  61 => 0x00000000007E00007E00000000000000,
   62 => 0x0000006030180C060C18306000000000,  63 => 0x00007CC6C60C18181800181800000000,
   64 => 0x0000007CC6C6DEDEDEDCC07C00000000,  65 => 0x000010386CC6C6FEC6C6C6C600000000,
   66 => 0x0000FC6666667C66666666FC00000000,  67 => 0x00003C66C2C0C0C0C0C2663C00000000,
   68 => 0x0000F86C6666666666666CF800000000,  69 => 0x0000FE6662687868606266FE00000000,
   70 => 0x0000FE6662687868606060F000000000,  71 => 0x00003C66C2C0C0DEC6C6663A00000000,
   72 => 0x0000C6C6C6C6FEC6C6C6C6C600000000,  73 => 0x00003C18181818181818183C00000000,
   74 => 0x00001E0C0C0C0C0CCCCCCC7800000000,  75 => 0x0000E666666C78786C6666E600000000,
   76 => 0x0000F06060606060606266FE00000000,  77 => 0x0000C3E7FFFFDBC3C3C3C3C300000000,
   78 => 0x0000C6E6F6FEDECEC6C6C6C600000000,  79 => 0x00007CC6C6C6C6C6C6C6C67C00000000,
   80 => 0x0000FC6666667C60606060F000000000,  81 => 0x00007CC6C6C6C6C6C6D6DE7C0C0E0000,
   82 => 0x0000FC6666667C6C666666E600000000,  83 => 0x00007CC6C660380C06C6C67C00000000,
   84 => 0x0000FFDB991818181818183C00000000,  85 => 0x0000C6C6C6C6C6C6C6C6C67C00000000,
   86 => 0x0000C3C3C3C3C3C3C3663C1800000000,  87 => 0x0000C3C3C3C3C3DBDBFF666600000000,
   88 => 0x0000C3C3663C18183C66C3C300000000,  89 => 0x0000C3C3C3663C181818183C00000000,
   90 => 0x0000FFC3860C183060C1C3FF00000000,  91 => 0x00003C30303030303030303C00000000,
   92 => 0x00000080C0E070381C0E060200000000,  93 => 0x00003C0C0C0C0C0C0C0C0C3C00000000,
   94 => 0x10386CC6000000000000000000000000,  95 => 0x00000000000000000000000000FF0000,
   96 => 0x30301800000000000000000000000000,  97 => 0x0000000000780C7CCCCCCC7600000000,
   98 => 0x0000E06060786C666666667C00000000,  99 => 0x00000000007CC6C0C0C0C67C00000000,
  100 => 0x00001C0C0C3C6CCCCCCCCC7600000000, 101 => 0x00000000007CC6FEC0C0C67C00000000,
  102 => 0x0000386C6460F060606060F000000000, 103 => 0x000000000076CCCCCCCCCC7C0CCC7800,
  104 => 0x0000E060606C7666666666E600000000, 105 => 0x00001818003818181818183C00000000,
  106 => 0x00000606000E06060606060666663C00, 107 => 0x0000E06060666C78786C66E600000000,
  108 => 0x00003818181818181818183C00000000, 109 => 0x0000000000E6FFDBDBDBDBDB00000000,
  110 => 0x0000000000DC66666666666600000000, 111 => 0x00000000007CC6C6C6C6C67C00000000,
  112 => 0x0000000000DC66666666667C6060F000, 113 => 0x000000000076CCCCCCCCCC7C0C0C1E00,
  114 => 0x0000000000DC7666606060F000000000, 115 => 0x00000000007CC660380CC67C00000000,
  116 => 0x0000103030FC30303030361C00000000, 117 => 0x0000000000CCCCCCCCCCCC7600000000,
  118 => 0x0000000000C3C3C3C3663C1800000000, 119 => 0x0000000000C3C3C3DBDBFF6600000000,
  120 => 0x0000000000C3663C183C66C300000000, 121 => 0x0000000000C6C6C6C6C6C67E060CF800,
  122 => 0x0000000000FECC183060C6FE00000000, 123 => 0x00000E18181870181818180E00000000,
  124 => 0x00001818181800181818181800000000, 125 => 0x0000701818180E181818187000000000,
  126 => 0x000076DC000000000000000000000000,
}.freeze

CW = 8  # glyph width
CH = 16  # glyph height

def chunk(type, body)
  [body.bytesize].pack("N") + type + body + [Zlib.crc32(type + body)].pack("N")
end

# rows: 0/1 arrays of width w each, written as 1-bit grayscale (0 = black)
def png(rows)
  w = rows[0].size
  raw = rows.map { |r|
    "\0".b + r.each_slice(8).map { |s| s.each_with_index.sum { |b, i| b << (7 - i) } }.pack("C*")
  }.join
  "\x89PNG\r\n\x1a\n".b +
    chunk("IHDR", [w, rows.size].pack("N2") + [1, 0, 0, 0, 0].pack("C5")) +
    chunk("IDAT", Zlib::Deflate.deflate(raw, 9)) + chunk("IEND", "")
end

def thumbnail
  src = File.readlines(File.join(__dir__, "..", "qc.rb"), chomp: true)
  w = src.map(&:size).max
  rows = Array.new(src.size * CH) { Array.new(w * CW, 0) }
  src.each_with_index do |line, j|
    line.each_char.with_index do |ch, i|
      bits = GLYPHS[ch.ord] or next
      CH.times do |y|
        row = (bits >> ((CH - 1 - y) * 8)) & 0xFF
        8.times { |x| rows[j * CH + y][i * CW + x] = (row >> (7 - x)) & 1 }
      end
    end
  end
  out = File.join(__dir__, "..", "images", "thumbnail.png")
  File.binwrite(out, png(rows))
  puts "#{out}: #{w * CW} x #{rows.size}"
end

# Run as a script it draws everything; required from elsewhere (the video) it only provides the parts
if $PROGRAM_NAME == __FILE__
  figure2
  figure3
  logo
  thumbnail
end
