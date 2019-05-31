FROM php:7.3.5-fpm-alpine3.9 as base

FROM nginx:1.16.0-alpine as nginx-builder

FROM base
COPY --from=nginx-builder /etc/nginx /etc/nginx
COPY --from=nginx-builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=nginx-builder /usr/lib/nginx/modules /usr/lib/nginx/modules
COPY --from=nginx-builder /var/log/nginx /var/log/nginx
COPY --from=nginx-builder /var/cache/nginx /var/cache/nginx
COPY --from=nginx-builder /usr/lib/libpcre* /usr/lib/
COPY --from=nginx-builder /usr/lib/libssl* /usr/lib/
COPY --from=nginx-builder /usr/lib/libcrypto* /usr/lib/
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf
COPY conf/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY phpinfo.php /var/www/html/index.php
COPY script/start.sh /start.sh
RUN chmod 755 /start.sh
EXPOSE 80 443
STOPSIGNAL SIGTERM

CMD ["/start.sh"]

