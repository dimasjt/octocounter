# Octocounter


## Installation

`$ gem install octocounter`

## Usage

* show biggest count

`$ octocounter path/to/directory`

* show all list files

`$ octocounter path/to/directory --all`

## Result

| Files                  | Content     | Count |
|------------------------|-------------|-------|
| test/data/A/content2<br>test/data/B/D/content3<br>test/data/B/content1   | bcdef       | 3     |
| test/data/B/D/diff     | bcdefghijkl | 1     |

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
