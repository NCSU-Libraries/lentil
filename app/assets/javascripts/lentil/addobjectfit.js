//= require polyfill.object-fit/polyfill.object-fit

function addobjectfit() {
  objectFit.polyfill({
    selector: '.square-media',
    fittype: 'cover',
    disableCrossDomain: 'true'
  });
}
