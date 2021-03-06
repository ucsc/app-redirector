# Redirector

A Sinatra app to redirect CNAMEs to other sites and internal pages.

## Purpose

This app acts as a simple relay from a CNAME to another URL without needing a web server as a middle layer. We track the traffic to the domains in this app by sending 'redirect' events to Google Analytics each time a visitor is redirected.

We use this app to:

- Redirect CNAMEs to internal pages on other sites.
- Retire CNAMEs on the UC Santa Cruz domain (ucsc.edu) by pointing them to a different site.

## How this app works

1. This app is written in Ruby, using [Sinatra][1]. It runs on a Heroku Hobby Dyno.
2. It uses a [hash stored in the settings block][2] of `app.rb` to store CNAMEs and corresponding redirect URLs.
3. When a request comes in, the request's `SERVER_NAME` value is used to check the hash for a corresponding key.
4. If there is a key for `SERVER_NAME`, the app will redirect the request to the value for that key, a URL. If there is no key, the app will show a 404 screen and let the user know there is no redirect configured for the requested `SERVER_NAME`.

## How to add a new redirect

1. Edit `app.rb` to add a CNAME and redirect to the [redirects settings hash][2].
2. In Heroku, [add the domain to the project][3].
3. [Request a new DNS record][4] for the CNAME by submitting a help ticket. The record should be a CNAME record. The target should follow this pattern: `<SUBDOMAIN>.ucsc.edu.herokudns.com`. Replace `<SUBDOMAIN>` with the CNAME you wish to configure.
4. Once the DNS record takes effect, visit your CNAME and you will be redirected to the URL you specificed in the settings hash.
5. HTTPS is configured by default on all Heroku custom domains. So the redirect will work over HTTP or HTTPS requests.

## Checking to see if a CNAME is configured

Go to [/debug/`<DOMAIN>`][5] and replace `<DOMAIN>` with a CNAME to see if that CNAME is configured. **Note:** this does not check that DNS settings are correct. You can check DNS configuration by typing `dig <DOMAIN>` in a terminal window on your computer.

## Google Analytics

This app uses the [staccato gem][6] to track redirects as `events` in Google Analytics.

[1]: http://sinatrarb.com
[2]: https://github.com/ucsc/ucsc-redirector/blob/master/app.rb#L8
[3]: https://devcenter.heroku.com/articles/custom-domains
[4]: https://its.ucsc.edu/network/hostnames/
[5]: https://ucsc-redirector.herokuapp.com/debug/
[6]: https://rubygems.org/gems/staccato
