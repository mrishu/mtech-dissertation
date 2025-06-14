// global
#import "lib.typ": template

//local
#import "customization/colors.typ": *


#show: template.with(
  author: "Aditya Dutta",
  title: "Explaining Query Expansion Algorithms",
  supervisor1: "Mandar Mitra",
  supervisor2: "",
  degree: "M.Tech.",
  program: "Computer Science",
  university: "Indian Statistical Institute",
  institute: "",
  deadline: datetime.today().display(),
  city: "Kolkata",

  // file paths for logos etc.
  uni-logo: image("images/isi.svg", width: 50%),

  // formatting settings
  body-font: "Libertinus Serif",
  cover-font: "Libertinus Serif",

  // chapters that need special placement
  abstract: include "chapter/0-abstract.typ", 
  acknowledgement: include "chapter/01-acknowledgement.typ",

  // equation settings
  equate-settings: (breakable: true, sub-numbering: true, number-mode: "label"),
	equation-numbering-pattern: "(1.1)",

  // colors
  cover-color: color1,
  heading-color: color2,
  link-color: color3
)

// ------------------- content -------------------
#include "chapter/1-intro.typ"
#include "chapter/3-query_expansion.typ"
#include "chapter/4-hypothesis.typ"
// #include "chapter/2-dataset.typ"
#include "chapter/5-similarities.typ"
#include "chapter/6-ieq.typ"
#include "chapter/7-results.typ"
#include "chapter/8-restricted_ground_truth.typ"
#include "chapter/9-pruning.typ"

// ------------------- bibliography -------------------
#bibliography("references.yml", full: true)

// ------------------- declaration -------------------
#include "chapter/999-declaration.typ"
#include "chapter/99-supervisor.typ"
