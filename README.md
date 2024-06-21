UMN Multilevel Modeling + Climate Data Workshop
================

### Using R to understand climate and population health

## Welcome!

Welcome to the home page for the 2024 UMN Multilevel Modeling and
Climate Data workshop.

This GitHub repository contains presentation slides and other materials
that will be used in the workshop.

Below we describe some setup work that can be completed before the
workshop itself. Please follow the instructions in advance of the
workshop. The day before the workshop (July 1) we will be available to
assist in some of these steps, but they can also be completed on your
own.

All data and software used in the workshop are available free of charge.

## Setup: Please complete prior to workshop!

### 1. Log into IPUMS DHS

To obtain access to IPUMS DHS, you must first
[register](https://dhsprogram.com/data/new-user-registration.cfm) for
data access through the DHS Program itself.

Once you have a valid DHS account, you can [log into IPUMS
DHS](https://www.idhsdata.org/idhs-action/users/login) using your DHS
username and password. :key:

### 2. Build an IPUMS DHS extract

You can generate a data extract containing the same samples and
variables that are used in this workshop through your own IPUMS DHS
account.

If you’re new to IPUMS DHS, [click
here](https://www.idhsdata.org/idhs/user_guide.shtml) for instructions
on building an IPUMS DHS data extract.

1.  To reproduce the data used in this workshop, select the following
    samples and variables:
    - **Sample:** Kenya 2014 :kenya:
    - **Variables:** (CONFIRM)
      - [`BIRTHWT`](%60r%20ipumsr::ipums_website(%22dhs%22,%20launch%20=%20FALSE,%20var%20=%20%22BIRTHWT%22)%60)
      - [`HEIGHTFEM`](%60r%20ipumsr::ipums_website(%22dhs%22,%20launch%20=%20FALSE,%20var%20=%20%22HEIGHTFEM%22)%60)
      - [`KIDSEX`](%60r%20ipumsr::ipums_website(%22dhs%22,%20launch%20=%20FALSE,%20var%20=%20%22KIDSEX%22)%60)
      - [`KIDDOBCMC`](%60r%20ipumsr::ipums_website(%22dhs%22,%20launch%20=%20FALSE,%20var%20=%20%22KIDDOBCMC%22)%60)
      - [`BIRTHWTREF`](%60r%20ipumsr::ipums_website(%22dhs%22,%20launch%20=%20FALSE,%20var%20=%20%22BIRTHWTREF%22)%60)
      - [`FLOOR`](https://idhsdata.org/idhs-action/variables/FLOOR)
      - [`TOILETTYPE`](https://idhsdata.org/idhs-action/variables/TOILETTYPE)
      - [`DRINKWTR`](https://idhsdata.org/idhs-action/variables/DRINKWTR)
      - [`HWHAZWHO`](https://idhsdata.org/idhs-action/variables/HWHAZWHO)
      - [`FEVRECENT`](https://idhsdata.org/idhs-action/variables/FEVRECENT)
      - [`DIARRECENT`](https://idhsdata.org/idhs-action/variables/DIARRECENT)
2.  Submit your extract request through the IPUMS DHS interface.
3.  When the it has finished processing,
    [download](https://tech.popdata.org/dhs-research-hub/posts/2024-02-02-download-dhs-data/#download-data)
    the completed data extract.
    - You will need to download **two** files (`.dat.gz` and `.xml`).
      See the [download
      instructions](https://tech.popdata.org/dhs-research-hub/posts/2024-02-02-download-dhs-data/#download-data)
      for information about how to obtain each.
    - Save both files into this project’s `data` sub-directory

### 3. Install R + RStudio

If you *do not* already have R and RStudio installed:

- [Install R](https://cran.r-project.org/) by clicking the appropriate
  link(s) for the operating system you’re running.
- [Install
  RStudio](https://www.rstudio.com/products/rstudio/download/#download)
  by clicking the *Download RStudio Desktop* button.

### 4. Download workshop files

There are 2 options for downloading the files used in this workshop:

1.  *If you’re comfortable with Git*, run the following code in your
    terminal to clone this repository into the local directory of your
    choice:

<!-- -->

    git clone https://github.com/IPUMS-Global-Health/umn-nairobi-2024.git

2.  *Otherwise*, you can
    [download](https://github.com/IPUMS-Global-Health/umn-nairobi-2024/archive/refs/heads/main.zip)
    the workshop files manually
    - :open_file_folder: Open the downloaded zip file
    - :rotating_light: **Windows users** may also need to download
      decompression software (e.g. [7-Zip](https://www.7-zip.org/)) to
      decompress the zip file.

### 5. Launch the workshop’s RStudio Project

Open the file `umn-nairobi-2024.Rproj` found in this project folder.

This will launch the workshop project in a new RStudio environment.
:rocket:

### 6. Install necessary R packages

Copy the following code into the `Console` in RStudio, then press
`Enter`.

``` r
# Install necessary packages if not already installed 
pkgs <- c("tidyverse", "ipumsr", "sf", "terra", "ggspatial", "lme4")

for (pkg in pkgs) {
  if (!require(pkg, quietly = TRUE, character.only = TRUE)) {
    install.packages(pkg)
  }
}
```

It may take a few minutes to install the packages needed for this
workshop :hourglass:

- If prompted to update dependency packages, please do so by pressing
  `1`.
- If asked
  `Do you want to install from sources the package which needs compilation?`,
  reply *No*
- Restart R at least once before the workshop begins. Do so by clicking
  *Session \> Restart R* in the header toolbar.

### That’s it!

You should now be ready to follow along with the workshop!

## Slides and Source Code

Workshop slides were built with [Quarto and
Revealjs](https://quarto.org/docs/presentations/revealjs/).
