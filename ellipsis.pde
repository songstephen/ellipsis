// ellipsis filter
// by stephen song (www.stephensong.com)

// inspiration
// http://lotek.fr/log/wp-content/uploads/2014/07/dots49363.png
// http://byrodrigo.files.wordpress.com/2010/09/nightcolorellipse.jpg
// http://byrodrigo.wordpress.com/resources/processing/intermediate-me-gusta-face-detection/

PImage src, dst;
String imageName = "berserker.jpg";
boolean shrink = false;

static final int maxImageSize = 1600;
static final int maxWidth = 1600;
static final int maxHeight = 1600;
static int size = 6;

// hue based color schemes
// TODO: make a mode so that if enabled, takes the darkest color in the palette
// and makes that the background, and have it ignored from the final palette

color bgCol = color(21,21,21);

color[] primary = {#F75454, #F7EF54, #5CFF72, #54C4F7, #705FDE};
color[] sunset = {#2A2F28, #CBA75B, #DCD747, #EF8D34, #EA7138};
color[] startear = {#4477ee, #7799ee, #7788dd, #ccccee, #aabbee};
color[] goldfish = {#69D2E7, #A7DBD8, #E0E4CC, #F38630, #FA6900};
color[] palette = startear;

void setup() {
      src = loadImage(imageName);
      if (shrink) {
            if(src.width > src.height && src.width > maxImageSize) {
            float scaleFactor = (float)maxImageSize / src.width;
            src.resize(round(scaleFactor * src.width), round(scaleFactor * src.height));
          } else if(src.height > src.width && src.height > maxImageSize) {
            float scaleFactor = (float)maxImageSize / src.height;
            src.resize(round(scaleFactor * src.width), round(scaleFactor * src.height));
          }
      }
      

      size(src.width, src.height);
      PImage src = loadImage(imageName);
      //posterize_g(src, 2);

      noStroke();

    //thr.loadPixels();

    //image(src, 0, 0);

    background(bgCol);
    
    //background(src);

    //blendMode(SCREEN);

    for (int i = 0; i < src.width; i += size) {
        for (int j = 0; j < src.height; j += size) {

            // corner pixels
            //color col = src.get(i, j);

            // average region
            color col = avg(src, i, j);

            float b = brightness(col);
            //fill(col);
            fill(pal(col));

            // dark is small
            float gap = size * b / 255;

            // dark is large
            // float gap = size * (1 - b / 255);

            rect(i + size - gap / 2, j + size - gap / 2, gap, gap);
        }
    }
    save("out.png"); //save the current screen image
}

int pixIX(int x, int y){
  return x + y * src.width;
}

color pal(color col) {
    int index = -1;
    float lowDif = 0;
    for (int i = 0; i < palette.length; i++) {
        color curr = palette[i];
        float diff = sq(red(col) - red(curr)) + sq(green(col) - green(curr)) + sq(blue(col) - blue(curr));
        if (index < 0 || diff < lowDif) {
            lowDif = diff;
            index = i;
        }
    }
    return palette[index];
}

color avg(PImage im, int x, int y) {
    PVector col = new PVector();
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            color tmp = im.get(x + i, y + j);
            col.add(red(tmp), green(tmp), blue(tmp));
        }
    }
    col.div(sq(size));
    return color(col.x, col.y, col.z);
}

void posterize_g(PImage im, int levels){
   im.loadPixels();
   if(levels>256){levels=256;}
   if(levels<2){levels=2;}
   for(int i=0;i<im.pixels.length;++i){
     float c=red(im.pixels[i]) * 0.3 + green(im.pixels[i]) * 0.6 + blue(im.pixels[i]) * 0.1;
     im.pixels[i]=color((float)((int)(c*levels))/levels);
    }
    im.updatePixels();
 }
