# Changelog


## 0.9.0
_27 May 2021_

**Breaking**
- `.github` style was renamed to `.md` to clarify it's markdown
- `StyleConfig.col_sep` got renamed to `StyleConfig.colsep` and has no default value anymore

**Additions**
- unicode widechars (e.g. chinese chars) are now supported _(somewhat experimental)_
- predefined `.rst` style for [reStructuredText][rst-docs]
- `Table`: enforce a value for the `custom_style` field when `style: .custom` is set
- ci: add a build and vet steps

**Changes**
- ci: remove dependency on setup-vlang-action
- ci: more diverse and stricter checks
- keep up with latest changes in V

## 0.8.0
_17 November 2020_

**Additions**
- Support for definition of custom styles
- Validate the given table property values to prevent V panics


## 0.7.0
_16 November 2020_

**Additions**
- Implement proper tab support

**Fixes**
- Fix behaviour of various styles with padding of zero
- Do not print a header sepline for single rowed tables


## 0.6.0
_09 November 2020_

**Additions**
- Basic Unicode symbol support
- Tab support

**Fixes**
- Remove seplines between rows in github style


## 0.5.0
_04 November 2020_

**Additions**
- Add a total of four new styles: `.simple`, `.pretty`, `.github`, `.fancy_grid`

## 0.4.0
_31 October 2020_

**Additions**
- Choose from a set of predefined table styles using the `style` property
- Bring back plain text headers. Choose what you want with `header_style`

**Changes**
- Readme: small improvements and clarifications


## 0.3.0
_24 October 2020_

**Additions**
- Print headers in bold
- New `orientation` config

**Fixes**
- Use the actual padding value to create the seperator line
- Readme: fix import line in Usage example


## 0.2.0
_23 October 2020_

**Additions**
- New `align` config to control cell item alignment
- New `padding` config to set the minimum space between cell separator and item
- Readme: add description and sections about installation and usage
- Add GH Sponsors button


## 0.1.0
_22 October 2020_

**Breaking**
- `Table`: replace `show()` with `str()`, so you now have to print it on your own

**Additions**
- Test every line of code (it was splitted into small functions to allow this)
- CI workflow that checks formatting and runs tests


## 0.0.1
_21 October 2020_

- Just table printing


<!-- Links -->
[rst-docs]: https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html
