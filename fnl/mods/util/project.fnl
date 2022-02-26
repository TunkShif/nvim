(module mods.util.project)

(let [project (require :project_nvim)
      telescope (require :telescope)]
  (project.setup {})
  (telescope.load_extension "projects"))
