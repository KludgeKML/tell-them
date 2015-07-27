namespace :build do
  desc 'Compile assets and build gem'
  task :gem do
    `sass --style compressed app/assets/stylesheets/tell-them.sass app/assets/stylesheets/tell-them.css`
    `coffee --compile app/assets/javascripts/tell-them.coffee`
    `gem build tell-them.gemspec`
  end
end