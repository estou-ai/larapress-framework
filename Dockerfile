FROM wordpress:latest

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip \
    && rm -rf /var/lib/apt/lists/*

ENV COMPOSER_ALLOW_SUPERUSER=1

# docker-entrypoint.sh instala o core do WordPress no $PWD, que precisa ser /var/www/html
RUN printf '#!/bin/bash\ncase "$1" in apache2*|php-fpm*) cd /var/www/html ;; esac\nexec docker-entrypoint.sh "$@"\n' \
      > /usr/local/bin/larapress-entrypoint.sh \
    && chmod +x /usr/local/bin/larapress-entrypoint.sh

WORKDIR /var/www/html/framework

ENTRYPOINT ["larapress-entrypoint.sh"]
CMD ["apache2-foreground"]
