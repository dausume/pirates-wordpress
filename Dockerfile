# Use the official PHP image as base
FROM php:7.4-apache

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    wget \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip

# Download WordPress and extract it
RUN wget -q -O wordpress.tar.gz https://wordpress.org/latest.tar.gz

RUN tar -xzf wordpress.tar.gz
RUN rm wordpress.tar.gz

# Set ownership and permissions
#RUN chown -R www-data:www-data /wordpress
#RUN chmod -R 755 /wordpress

# Set up Apache
RUN a2enmod rewrite

# Replace this with wp config create
COPY ./wp-config.php ./wordpress

# Change permissions
# need to change owner of directory to www-data  (this gives permissions to the apache process as a user)
# the apache user is created during the apache install process
RUN chown -R www-data:www-data /wordpress

# Will need to do this using an entrypoint file.
#RUN wp config create --dbname=wordpress_db --dbuser=wordpress_user --dbpass=example_password --dbhost=localhost --dbprefix=wp_ --skip-check

#RUN wget 

# Basic/Essential Plugins
# Classic Editor - So you can configure stuff.
# Contact Form 7 - Contact Management and general info gathering via campaigns.
# Newsletter - Lets you make a Newsletter and send it out to people via emails.
# Cloudflare - for proxies and third party SSL, need to know how cache is being managed.
# Mailgun - free email service for up to 1000 emails a month.
# ReallySimpleCaptcha - Gives you Re-Captcha? via google.

# Extra Plugins
# WP-Supercache
# Contact Form C7DB
# SCO-Framework
# S2-Member-Framework - Triggers events on member signup, integrates with WP-User-Management (Don't enable if you don't
# need it, if not configured properly can cause security risk)

# Use to 
# wp plugin install plugin-slug

# Start Apache in the foreground
CMD ["apache2-foreground"]