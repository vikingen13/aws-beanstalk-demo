REGION=eu-west-1 
env-name=drupal
team=blue

CreateEnv:
	figlet "Create BeanStalk"
	curl https://ftp.drupal.org/files/projects/drupal-9.4.3.tar.gz -o drupal.tar.gz
	tar -xvf drupal.tar.gz
	mv drupal-9.4.3 $(env-name)
	cd $(env-name);unzip ../eb-php-drupal-v1.zip;eb init --platform php-8.0 --region $(REGION) --tags Team=$(team);eb init;eb create $(env-name) --database.version 5.7
	rm drupal.tar.gz
	cd $(env-name);eb open
	