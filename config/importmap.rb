# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
# pin "bootstrap", to: "bootstrap.min.js", preload: true
# pin "@popperjs/core", to: "popper.js", preload: true
pin "mapbox-gl", to: "https://ga.jspm.io/npm:mapbox-gl@3.1.2/dist/mapbox-gl.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.1.0/nodelibs/browser/process-production.js"
pin "stimulus-confetti", to: "https://ga.jspm.io/npm:stimulus-confetti@1.0.1/dist/stimulus_confetti.modern.js"
pin "canvas-confetti", to: "https://ga.jspm.io/npm:canvas-confetti@1.9.3/dist/confetti.module.mjs"
pin "toastr", to: "https://ga.jspm.io/npm:toastr@2.1.4/toastr.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js"
