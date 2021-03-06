FROM phusion/passenger-ruby24:1.0.6

ENV HOME /root

CMD ["/sbin/my_init"]

ENV DEBIAN_FRONTEND noninteractive

RUN bash -lc 'apt-get update'
RUN bash -lc 'apt-get install -y tzdata'
RUN bash -lc 'ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime'
RUN bash -lc 'dpkg-reconfigure --frontend noninteractive tzdata'

# Set the default Ruby version for app
RUN bash -lc 'rvm get head --auto-dotfiles'
RUN bash -lc 'rvm install ruby-2.4.3'
RUN bash -lc 'rvm --default use ruby-2.4.3'
RUN bash -lc 'gem install bundler'

# Build the bundle before adding app, to cache bundle in Docker image
COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bash -lc 'rvm-exec 2.4.3 bundle install --jobs 8'

# Enable Nginx and Passenger
RUN rm -f /etc/service/nginx/down

RUN rm /etc/nginx/sites-enabled/default
ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf

# Set environment variables for app in each Passenger instance
ADD docker-env.conf /etc/nginx/main.d/docker-env.conf

# Copy app and setup
RUN mkdir /home/app/webapp

COPY . /home/app/webapp
COPY script/docker/rails-init /usr/local/bin/rails-init

RUN chown -R app:app /home/app/webapp \
 && chmod +x /usr/local/bin/rails-init

WORKDIR /home/app/webapp

RUN touch log/production.log
RUN chmod 0664 log/production.log

# Make sure all app is owned by user "app"
RUN chown -R app:app ./

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
