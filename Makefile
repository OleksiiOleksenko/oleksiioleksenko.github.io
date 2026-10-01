update:
	bundle install
	bundle update

serve:
	bundle exec jekyll serve --config _config.yml,_config-dev.yml

open:
	firefox http://localhost:4000

test:
	bundle exec htmlproofer ./_site

