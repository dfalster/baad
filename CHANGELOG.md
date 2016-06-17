# Changelog for the Biomass And Allometry Database for woody plants (BAAD)

For full information about the database and obtaining it, see [the main readme file](https://github.com/dfalster/baad/).

For more fine-grained list of changes or to report a bug, consult

* [The issues log](https://github.com/dfalster/baad/issues)
* [The commit log](https://github.com/dfalster/baad/commits/master)
* [The releases page](https://github.com/dfalster/baad/releases).

Versioning
----------

Releases will be numbered with the following semantic versioning format:

<major>.<minor>.<patch>

And constructed with the following guidelines, with respect to changes in the **generated outputs**:

* Breaking backward compatibility bumps the major (and resets the minor
  and patch)
* New additions without breaking backward compatibility bumps the minor
  (and resets the patch)
* Bug fixes and misc changes bumps the patch

For more information on semantic versioning, please visit http://semver.org/.

To access a specific version, e.g. `1.0.0` using the [baad.data](https://github.com/traitecoevo/baad.data) package for R run

    baad.data:::data("1.0.0")

## v1.0.0

This is the version of the database associated with the corresponding paper in the journal [*Ecology*]. [Link](http://www.esapubs.org/archive/ecol/E096/128/) and posted on Ecological Archives.

* First version recommended for public use
* Switch to using remake package to build BAAD
* Lots of changes associated with preparation of the paper for Ecology, including updates to contact information
* Also add baad's git info to colophon

See here for all changes in the code between versions: [v0.9.0...v1.0.0](https://github.com/dfalster/baad/compare/v0.9.0...v1.0.0)

## v0.9.0

This is version sent to co-authors for final check prior to resubmission of paper for publication Ecology.

* Minor edits to paper for Ecology
* Monserud1999 - Fix methods and contact
* Battaglia1998 - added heartwood at breast height

See here for a full comparison of the code between versions: [v0.9.0...v1.0.0](https://github.com/dfalster/baad/compare/v0.2.0...v0.9.0)

## v0.2.0

Earliest release, for posterity's sake only. This is the version submitted for review at Ecology.
