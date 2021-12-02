# ISBN

A Swift package for parsing ISBN strings into a type-safe struct.
The package handles both ISBN10 and ISBN13, with or without hyphenation,
and can output normalized strings in several different formats.
Besides validating the checksum digit, the parser also divides the ISBN
into its constituent parts – country code, registration group,
registrant, and publication – making it possible, for example,
to aggregate ISBNs from the same publisher.


## Installation

ISBN is distributed with the [Swift Package Manager](https://swift.org/package-manager/). 
Add the following code to your `Package.swift` manifest.

``` Swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/iansampson/ISBN", .branch("main"))
    ],
    ...
)
```


## Usage

To parse an ISBN, simply initialize an `ISBN` object with a string:

``` Swift
let isbn = try ISBN("978-0-8223-5656-1")
```

The constructor accepts strings in either ISBN10 or ISBN13,
with or without hyphenation (although the hyphens must fall 
between valid ISBN components).

You can access the individual components as properties:

``` Swift
isbn.countryCode
isbn.registrationGroup
isbn.registrant
isbn.publication
```

To re-encode the ISBN as a normalized string,
use one of the following methods:

``` Swift
isbn.string // 978-0-8223-5656-1
isbn.string(format: .isbn10, hyphenated: false) // 0822356562
```

If `format` is set to `.isbn10` and the ISBN is prefixed
with 979 (i.e. the “musicland” country code), the second method
returns nil. Since all ISBN10s are implicitly prefixed with 978,
there is no way to encode a musical ISBN using only 10 digits.
In all other cases, the method returns a string.
