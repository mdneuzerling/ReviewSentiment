devtools::load_all()
package_name <- basename(here::here())
# drake::expose_imports(package_name, character_only = TRUE)
plan <- training_plan()
drake::vis_drake_graph(plan)
drake::make(plan)
build_times()

