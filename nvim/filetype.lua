vim.filetype.add({
  pattern = {
    [".*/dbt.*/.*%.sql"] = "sql.jinja",
  },
})
