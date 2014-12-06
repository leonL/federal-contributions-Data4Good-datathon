About the Data
==============

Introduction
------------

The contributions data found in this repository  was sourced from the [Elections Canada website](http://www.elections.ca/WPAPPS/WPF/) in mid-2014. Elections Canada makes these records publicly available in two forms: as they were submitted, and with unspecified corrections made over the course of an internal review process. Though both sets were [scraped](https://github.com/saltire/election-contribs), the 'as submitted' data was elected for analysis because it was complete for all the years and parties of interest, whereas the 'reviewd' data was not. Hence the 'as submitted' data is the only set available in this repository. CSVs of the 'reviewed' data set can be found in [this other GitHub repository](https://github.com/leonL/federal-contributions-raw-data).

The data has been munged considerably (both cleaned and transformed) using a [series of R scripts](https://github.com/leonL/federal-contributions-munging). The munging scripts are slated to be refined to improve the accuracy of the data in early 2015.

The full data set contains roughly 1.5 million records. It has been split over a number of files - organized by party and year - for the sake of portability (files over 100MB cannot be pushed to GitHub). An R script is available in the munged_data folder that quickly concatenates all the data into a single CSV file.

Context : Federal Political Financing in Canada
-----------------------------------------------

Individual contributions make up a significant proportion of how federal parties have been financed over the last decade in Canada, and stand to become even more dominant now that the per-vote subsidy has been eliminated. See [Wikipedia](http://en.wikipedia.org/wiki/Federal_political_financing_in_Canada) for an introduction to Canada's political financing system.

Generally speaking, every Canadian is limited to contributing $1200 per year to any one federal party, as well as to any of its EDAs (electoral-district/riding associations). This limit has changed incrementally over the past decade; for the detailed limits per year, see the 'Contibution limit table' PDF in the 'docs' folder.

### Qualifitications

Political parties must account for the contributoins they recieve with Elections Canada only if they are in excess of $200. Accounting for smaller contributions is entirely voluntary.

There is no limit on the amount of a contribtuion that can be made in a person's will.

Metadata
--------

### Column Descriptions

**contributor_id** (generated)
A unique ID given to each contributor (for grouping all their contributions together).

**full_name** (unchanged)
The name of the contributor. Name's prefixed by 'Estate of' denote a contribution to a party left in the contributor's will. There is no limit on a contribution in this case.

**postal_code** (adjusted)
The Postal Code of the contributor. Only valid postal codes have been preserved. Invalid codes and blanks have been converted to the value NA.

**contribution_amount** (unchanged)
The amount of the contribution, in **cents**. Note that there is no limit on how big a contribution a Canadian can leave in their will. Such a contribution will be denotated by the prefix 'Estate of' in the full_name column.

**party_name** (generated)
The official name of the party to which the contribution was made.

**federal_contribution** (generated)
TRUE/FALSE values indicating whether the contribution was made directly to the federal party (TRUE) or one of its electoral-district/riding associations (FALSE).

**party_riding** (unchanged)
The name of the party, or electoral-district/riding association to which the contribution was made.

**target_riding** (generated)
The official name of the electoral-district/riding to which the contribution was made.

**contributors_riding_name** (generated)
The official name of the electoral-district/riding where the contributor resides.

**contributors_riding_id** (generated)
The official id of the electoral-district/riding where the contributor resides.

**city** (unchanged)
The contributor's city.

**province** (unchanged)
The contributor's province.

**contribution_date.adjusted** (adjusted)
The date of the contribution.

**flag.negative_contrib** (generated)
TRUE indicates that a contribution amount is a negative number. The meaning of negative contributions is yet unclear. They might be records to show that previous, positive contributions from the same contributor have been revoked.

**flag.blank_contrib** (generated)
TRUE indicates that the contribution amount of the original record was either blank or zero.

