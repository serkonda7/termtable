# Changelog


## 0.6.0
_09 November 2020_

**Additions**
- Basic Unicode symbol support
- Tab support

**Fixes**
- Remove lines between rows in github style


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
