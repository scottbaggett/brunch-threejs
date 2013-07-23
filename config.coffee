exports.config =
  # See docs at http://brunch.readthedocs.org/en/latest/config.html.
  files:
    javascripts:
      defaultExtension: 'coffee'
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^vendor/
      order:
        before: [
          'vendor/scripts/console-helper.js',
          'vendor/scripts/jquery-1.7.2.js',
          'vendor/scripts/underscore-1.3.3.js',
          'vendor/scripts/backbone.js',
          'vendor/scripts/backbone.stickit.js',
          'vendor/scripts/backbone.marionette.js'
          'vendor/scripts/threejs/three.js',
          'vendor/scripts/threejs/controls/OrbitControls.js',
          'vendor/scripts/stats.js',
          'vendor/scripts/buzz.js',
          'vendor/scripts/tween.js',
          'vendor/scripts/log.js'
        ]

    stylesheets:
      defaultExtension: 'styl'
      joinTo: 'stylesheets/app.css'
      order:
        before: ['vendor/styles/normalize.css']
        after: ['vendor/styles/helpers.css']

    templates:
      defaultExtension: 'hbs'
      joinTo: 'javascripts/app.js'
