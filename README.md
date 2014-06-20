#VK Photos

This is my sinatra-based VK.com photos-with-me downloader web app, made for my friend

To use it you must either visit [my site with it](vizvamitra.no-ip.com) (if it is online) or create your own app at vk.com to get **app id** and **app secret key**

*And don't forget to specify your domain name there in app settings*

### Running

To run this app in production you can use bash script like that:

    #!/bin/bash

    APP_ID=your_app_id APP_SECRET=your_app_secret DOMAIN_NAME=your_domain_name BIND_IP=ip_to_bind_app BIND_PORT=some_port RACK_ENV=production ruby app.rb >> log/app.log 2>&1

Otherwise you will need to somehow set APP_ID, APP_SECRET, DOMAIN_NAME, BIND_IP and BIND_PORT environment variables (or code them directly into app.rb or vk_photos.rb file)

### Behavior

- App encrypts archives with randomly generated password
- App schedules newly created archives to be removed in 1 hour

### Known issues

- This app can't download more than 1,000 photos due to vk.com API limits
- I haven't yet think out how to filter archive passwords from logs
- Any others, since I'm being lazy to write tests

### Contacts

You can contact me via email: vizvamitra@gmail.com

I'll be happy to get any feedback on this app.

Dmitrii Krasnov


