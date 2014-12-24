#! /usr/bin/env ocaml

#use "topfind";;
#require "csv";;

let inputs_csv = "../data/diabetes_data.csv"
let outputs_csv = "../data/diabetes_target.csv"
let combined_csv = "../data/diabetes_combined.csv"

let map_csv f csv =
  List.map (fun row -> List.map (fun el -> f el) row) csv

let () =
  let inputs = map_csv float_of_string (Csv.load ~separator:' ' inputs_csv) in
  let outputs = map_csv float_of_string (Csv.load ~separator:' ' outputs_csv) in
  let combined = List.map2 List.append inputs outputs in
  Csv.save combined_csv (map_csv string_of_float combined)
