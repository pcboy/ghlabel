# Ghlabel

ghlabel lets you set/unset labels on the PR related to the current branch you are on.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ghlabel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ghlabel

## Usage

```
$> ghlabel -h
  -t, --token-file=<s>                           File containing your github token (https://github.com/settings/tokens)
	-r, --repository=<s>                           The repository you are working on
	-o, --organization=<s>                         Your organization name
  -a, --add=<s>                                  --add label1,label2,label3
  -e, --remove=<s>                               --remove label1,label2,label3
  -w, --with-references, --no-with-references    Also apply labels to title referenced #issues_numbers (default: true)
  -h, --help                                     Show this message
```

Add QA,Review label to the current PR
```
ghlabel -t .github-token --add QA,Review
```

Remove QA,Review label to the current PR
```
ghlabel -t .github-token --remove QA,Review
```

If your PR contains some references to others issues with #issue\_number the corresponding issues will have their labels changed too.
You can prevent that behavior by adding --no-with-references

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ghlabel. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the WTFPL 

