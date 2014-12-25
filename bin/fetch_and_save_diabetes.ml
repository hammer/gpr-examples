#! /usr/bin/env ocaml

#use "topfind"
#require "csv"
#require "uri"
#require "cohttp.lwt"

let diabetes_uri = Uri.of_string "http://www4.stat.ncsu.edu/~boos/var.select/diabetes.rwrite1.txt"

(* TODO(hammer): use some path type here *)
(* TODO(hammer): intelligently get script location *)
(* TODO(hammer): mkdir -p data_dir *)
let home_dir = "./"
let data_dir = home_dir ^ "data/"
let diabetes_csv = data_dir ^ "diabetes.csv"

let fetch_and_save uri =
  let open Lwt in
  Cohttp_lwt_unix.Client.get uri >>= fun (resp, body) ->
  Cohttp_lwt_body.to_string body >>= fun b ->
  let data = List.tl (Csv.input_all(Csv.of_string ~separator:' ' b)) in
  return (Csv.save diabetes_csv data)

let () =
  Lwt_main.run (fetch_and_save diabetes_uri)
