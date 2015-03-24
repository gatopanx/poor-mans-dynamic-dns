# poor-mans-dynamic-dns

Dynamic DNS without headaches

Requires:

- Domain's DNS hosted with Route 53
- AWS access token with route53 privileges
- Bundler

Setup: 

- `git clone git@github.com:gatopan/poor-mans-dynamic-dns.git`
- `cd poor-mans-dynamic-dns`
- edit wrapper.sh to have two things:
 - current AWS REGION, ACCESS KEY ID & SECRET ACCESS KEY
 - target DOMAIN and SUBDOMAIN
- `bundle install`
- add  `wrapper.sh` to your crontab or run it on demand.
