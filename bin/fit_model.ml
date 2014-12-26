#! /usr/bin/env ocaml

#use "topfind"
#thread
#require "csv"
#require "lacaml"
#require "gpr"

open Lacaml.D

module Cov = Gpr.Cov_lin_one
module GP = Gpr.Fitc_gp.Make_deriv (Cov.Deriv)

let diabetes_csv = "data/diabetes.csv"

let csv_map f csv =
  List.map (fun row -> List.map (fun el -> f el) row) csv

let () =
  let csv = Csv.load diabetes_csv in
  let inputs_row_list = Csv.sub 0 0 (List.length csv) (Csv.columns csv - 1) csv in
  let targets_list = Csv.sub 0 (Csv.columns csv - 1) (List.length csv) 1 csv in
  let make_fvec row = Vec.of_list (List.map float_of_string row) in
  let inputs_array_vec = Array.of_list (List.map make_fvec inputs_row_list) in
  let inputs = Mat.of_col_vecs inputs_array_vec in
  let targets = Vec.of_list (List.map float_of_string (List.flatten targets_list)) in
  let params = { Cov.Params.log_theta = 0.5 } in
  let kernel = Cov.Eval.Kernel.create params in
  let trained = GP.Variational_FIC.Deriv.Optim.Gsl.train ~kernel ~inputs ~targets () in
  ()
